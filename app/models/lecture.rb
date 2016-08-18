class Lecture < ActiveRecord::Base

  include ActionView::Helpers::DateHelper

  validates :subject, presence: true, length: {maximum: 40}, uniqueness: {scope: [:professor, :major] }
  validates :professor, length: {maximum: 40}
  validates :major, presence:true

  has_many :valuations, dependent: :destroy
  has_many :schedules, -> {where recent: true}

  accepts_nested_attributes_for :schedules

  belongs_to :timetable

  accepts_nested_attributes_for :schedules

  scope :order_by_comments, -> { joins(:comments).order("comments.created_at DESC") }
  scope :group_by_id, ->  { group(:lecture_id)}
  scope :schedules_by_seme, -> (semester) { joins(:schedules).where("schedules.semester" => semester).select("schedules.*") }

  require 'rubygems'
  require 'roo'


  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)

    tempRow = Hash[[header, spreadsheet.row(2)].transpose]
    currentSemester = tempRow["semester"]

    Schedule.where("semester = ? ", currentSemester).update_all(recent: false)

    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      lecture = Lecture.new(major: row["major"], subject: row["subject"], isu: row["isu"],
                          professor: row["professor"], credit: row["credit"], open_department: row["open_department"])
      if lecture.valid?
        lecture.save
      else
        lecture = find_by(subject: row["subject"], professor: row["professor"])
        lecture.update_attributes(isu: row["isu"], credit: row["credit"],
                                         open_department: row["open_department"], major: row["major"])
      end
      schedule = lecture.schedules.new( lecture_time: row["lecturetime"], place: row["place"],
                                        semester: row["semester"], recent: true)
      # 이번학기 데이터를 선 구축후, 조건문 해석
      # 지금 등록하려는 강의 스케줄이 새로 변경 or 추가됨
      if schedule.valid?
        schedule.save
        ScheduleDetail.makeScheduleDetails(schedule.id, schedule.lecture_time)
      # 지금 등록하려는 강의 스케줄이 기존에 등록한 적 있음
      else
        schedule = Schedule.find_by(lecture_id: lecture.id, lecture_time: row["lecturetime"], semester: row["semester"], recent: "false")
        schedule.toggle(:recent)
        schedule.save
      end

    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end


  def update_avr_rating(rating)
    int_rating = rating.to_i

    # 강의의 별점이 처음 등록된 경우
    if self.avr_rating.nil?
        sum_rating = int_rating
    else
        sum_rating = self.avr_rating * self.valuations.count + int_rating
    end
    self.avr_rating = sum_rating/(self.valuations.count+1)
    self.save
  end


  def self.searchOnTimetable(search, semester)
    unless search.nil?
      where(['(professor LIKE ? OR subject LIKE ? OR open_department LIKE ?)',
         "#{search}%","%#{search}%","#{search}%"])
    end
  end

  def self.searchForValuation(search)
      unless search.nil?
         where(['professor LIKE ? OR subject Like ? OR open_department = ?',
        "#{search}%", "#{search}%", "#{search}"])
      end
  end

  def self.detailSearch(major, isu)
      where(['major LIKE ? OR isu Like ?', "#{major}%","#{isu}%"]).order('acc_total DESC')
  end

  def self.getLecturesBeSearched(searchWord, semester, pageSelected)
    @lecArr = []            # 검색 결과, 강의의 schedule 단위로 삽입
    @dataTojson = Hash.new	# 검색 결과 schedule 배열을 이 변수에 삽입

    @lectures = Lecture.searchOnTimetable(searchWord, semester)
    @dataTojson[:totalSearched] =  @lectures.schedules_by_seme(semester).size

    # 검색결과를 페이지당 8개씩 보여준다.
    # 2page 선택시, 전체 검색결과 중 8번째~15번째 record만 가져옴
    offsetByPage = (pageSelected.to_i - 1) * 8

    @schedulesPrinted = @lectures.schedules_by_seme(semester).offset(offsetByPage).limit(8)

    @schedulesPrinted.each do |sch|
      lectureObj = Hash.new

      lectureObj = Lecture.find(sch.lecture_id).as_json(only: [:subject, :professor, :open_department])
      lectureObj[:schedule_id] = sch.id

      schduleObj = sch.as_json(only: [:lecture_id, :lecture_time])
      lectureObj = lectureObj.merge(schduleObj)

      schDetailObjs = ScheduleDetail.where(schedule_id: sch.id)

      lectureObj[:schDetails] = schDetailObjs.as_json(only: [:start_time, :end_time, :day])


      @lecArr.push(lectureObj)
    end

    # pageSelected : 사용자가 선택한 페이지
    # pageTotal    : 검색결과 총 페이지
    @dataTojson[:pageSelected] = pageSelected
    @dataTojson[:finalPageNum] = (@dataTojson[:totalSearched] / 8) + ((@dataTojson[:totalSearched].to_i % 8 + 7) / 8)

    @dataTojson[:lectures] = @lecArr

    return @dataTojson

  end


end
