class ScheduleDetail < ActiveRecord::Base
  belongs_to :schedule, -> {includes :lecture}

  # 전환하고 저장하는거니까 메서드 명 포괄적으로 바꾸자.
  def self.makeScheduleDetails(scheduleId, lectureTime)
    cellTime = Hash.new

    # split and make method
    timeArr = lectureTime.split(",")
    timeArr.each do |t|
      if t.length > 12
        timeArr.push(t[1]+t[2..-1])
        t[1] = ""
      end
    end

    timeArr.each do |t|
      cellTime = makeCellTime(t[0], t[1..-1])
      ScheduleDetail.create(schedule_id: scheduleId, start_time: cellTime[:startTimeRowNum],
                  end_time: cellTime[:endTimeRowNum], day: cellTime[:dayColumnNum])
    end
  end

  def self.makeCellTime(day, time)
    cellTime = Hash.new
    timeSplited = splitLectureTime (time)
    cellTime[:dayColumnNum] = convertDayToDayColumnNum(day)
    cellTime[:startTimeRowNum] = convertTimeToTimeRowNum(timeSplited[0])
    cellTime[:endTimeRowNum] = convertTimeToTimeRowNum(timeSplited[1])
    cellTime
  end

  def self.splitLectureTime (time)
    refiendTime = time.split("-")
    refiendTime.each_with_index do |t, i|
      refiendTime[i] = t.delete ":"
    end
    refiendTime
  end

  def self.convertDayToDayColumnNum(day)

    dayStr = ["월","화","수","목","금","토"]

    dayStr.each_with_index do |dayChar, i|
      if (dayChar == day)
        return "v" + i.to_s
      end
    end
  end

  def self.convertTimeToTimeRowNum(time)
    if (time[2] == "3")
      time[2] = "5"
    end
    time
  end

end
