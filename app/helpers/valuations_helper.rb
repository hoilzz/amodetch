module ValuationsHelper

  def valuation_text_by_rating(rating)
    if rating < 2
      "별로에요"
    elsif rating < 3
      "보통이에요"
    elsif rating < 4
      "좋아요!"
    elsif rating <= 5
      "최고에요!"
    end
  end

  def replace_new_line(content)
    content.gsub(/\n/, "<br>").split("<br>").join("<br>")
  end

end
