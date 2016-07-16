class Lecture < ActiveRecord::Base

  include ActionView::Helpers::DateHelper

  validates :subject, presence: true, length: {maximum: 40}, uniqueness: {scope: [:professor] }
  validates :professor, length: {maximum: 40}
  validates :major, presence:true

  has_many :plural_attrs, dependent: :destroy
  has_many :comments
  has_many :valuations, dependent: :destroy
  has_many :comment_valuations, dependent: :destroy
  has_many :enrollment
  has_many :schedules, -> {where recent: true}

  belongs_to :timetable

  scope :order_by_comments, -> { joins(:comments).order("comments.created_at DESC") }
  scope :group_by_id, ->  { group(:lecture_id)}


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

  def self.extractSchedules(lecs, semester)
    lecs.joins(:schedules).where("schedules.semester" => semester).select("schedules.*")

  end

  def lec_valuation(counts,t)

    if self.acc_grade.nil?
        total = t.to_i
    else
        total = self.acc_total*counts + t.to_i
    end
    counts+=1
    self.acc_total = total/counts
  end

  def self.searchOnTimetable(search, semester)
    unless search.nil?
      where(['(professor LIKE ? OR subject LIKE ? OR open_department LIKE ?)',
         "#{search}%","%#{search}%","#{search}%"])
    end
  end

  def self.search_home(search)
      unless search.nil?
         where(['professor LIKE ? OR subject Like ? OR open_department = ?',
        "#{search}%", "#{search}%", "#{search}"]).select('DISTINCT id, subject, professor, major, isu, credit')
      end
  end

  def self.detailSearch(major, isu)
      where(['major LIKE ? OR isu Like ?', "#{major}%","#{isu}%"]).order('acc_total DESC')
  end

end



  # #def self.import(file)
  #   lec = Lecture.where('semester = "2016년 1학기"')
  #   lec.each do |l|
  #     l.update_attribute(:semester, nil)
  #     if l.plural_attrs
  #       l.plural_attrs.each do |p|
  #         p.destroy
  #       end
  #     end
  #   end
  #   spreadsheet = open_spreadsheet(file)
  #   header = spreadsheet.row(1)
  #   (2..spreadsheet.last_row).each do |i|
  #     row = Hash[[header, spreadsheet.row(i)].transpose]
  #     lecture = find_by(subject: row["subject"], professor: row["professor"])
  #
  #     if lecture
  #       lecture.update_attributes(isu: row["isu"], semester: row["semester"], credit: row["credit"],
  #                                 open_department: row["open_department"], major: row["major"])
  #     else
  #       lecture = Lecture.new
  #       lecture.update_attributes(isu: row["isu"], semester: row["semester"], credit: row["credit"],
  #                                 open_department: row["open_department"], major: row["major"],
  #                                 subject: row["subject"], professor: row["professor"])
  #     end
  #
  #     lec_plural_attrs = lecture.plural_attrs.build(lectureTime: row["lectureTime"], place: row["place"])
  #     lec_plural_attrs.save
  #     # 현재 엑셀의 column 개수와 업데이트 할 attr 개수 일치 확인.
  #     # lecture.attributes = row.to_hash.slice("subject", "professor", "major", "place", "isu","semester", "open_department", "credit")
  #     lecture.save
  #     #lecture.lecturetime = [row["lecturetime"]]
  #   end
  # end



  # 2 DB에 있는 강의에 몇가지 COLUMN 업데이트
  # def self.import(file)
  #   spreadsheet = open_spreadsheet(file)
  #   header = spreadsheet.row(1)
  #   (2..spreadsheet.last_row).each do |i|
  #     row = Hash[[header, spreadsheet.row(i)].transpose]
  #     @lecture = Lecture.find_by(subject: row["subject"], professor: row["professor"])
  #     # lecture = find_by_id(row["id"]) || new
  #     # lecture.update_attribute("isu", row["isu"] )
  #     # lecture.update_attribute("place", row["place"] )
  #     if @lecture
  #       @lecture.update_attribute("semester", row["semester"])
  #       @lecture.update_attribute("lecturetime", row["lecturetime"])
  #       @lecture.update_attribute("place", row["place"])
  #       @lecture.update_attribute("isu", row["isu"])
  #       @lecture.update_attribute("credit", row["credit"])
  #       @lecture.save
  #     end
  #   end
  # end



  # 3 DB에 있는 강의 중 lecturetime 업데이트.. 좀 복잡한거 설명 들어야함
  # def self.import(file)
  #   spreadsheet = open_spreadsheet(file)
  #   header = spreadsheet.row(1)
  #   (2..spreadsheet.last_row).each do |i|
  #     row = Hash[[header, spreadsheet.row(i)].transpose]
  #     lecture = Lecture.find_by(subject: row["subject"], professor: row["professor"])
  #     #lecture = find_by_id(row["id"]) || new
  #     # lecture.update_attribute("isu", row["isu"] )
  #     # lecture.update_attribute("place", row["place"] )

  #     # if lecture.lecturetime == nil
  #     if lecture
  #       @bool_value = true
  #         # 강의시간이
  #         if lecture.lecturetime.length != 0
  #           lecture.lecturetime.each do |time|
  #             if time == row["lecturetime"]
  #               @bool_value = false
  #             end
  #           end

  #         end

  #         if @bool_value
  #           lecture.lecturetime << row["lecturetime"]
  #         end
  #       lecture.save
  #     end
  #     # elsif lecture.lecturetime.length >= 1
  #     #   lecture.lecturetime << row["lecturetime"]
  #     # end
  #     # lecture.lecturetime = [row["lecturetime"]]
  #   end
  # end




  # 길우꺼
  # =>
  # def self.import(file)
  #   spreadsheet = open_spreadsheet(file)
  #   header = spreadsheet.row(1)
  #   (2..spreadsheet.last_row).each do |i|
  #     row = Hash[[header, spreadsheet.row(i)].transpose]
  #     row.to_hash.slice("subject", "professor", "major","lecturetime")
  #     @lecture= Lecture.where(subject: row["subject"], professor: row["professor"]).first

  #     byebug
  #    #첫번째 시도 시 하기
  #     @lecture.lecturetime = {:first => row["lecturetime"]}
  #   # 두번째 시도 시 하기


  #     # if(@lecture.lecturetime[:second].nil? && @lecture.lecturetime[:first] != row["lecturetime"])
  #     #   counts=@lecture.lecturetime.count

  #     #   counts.times do |i|
  #     #   end

  #     #   first=@lecture.lecturetime[:first]
  #     #   @lecture.lecturetime = {:first => first, :second => row["lecturetime"]}

  #     # elsif(@lecture.lecturetime[:third].nil? && @lecture.lecturetime[:first]!= row["lecturetime"]&&@lecture.lecturetime[:second]!= row["lecturetime"])

  #     #   first=@lecture.lecturetime[:first]
  #     #   second=@lecture.lecturetime[:second]
  #     #   @lecture.lecturetime = {:first => first, :second => second, :third => row["lecturetime"]}
  #     # end
  #   end
  # end
