class String
  def place(count)
    words = self.split(" ") # Все слова из текста
    compozition = "" # Композиция - строка не превышающая count_sym символов
    summary = []  # Коллекция наших композиций

    words.each do |word|
      if (compozition.size + word.size + 1) <= count then
        compozition += " " + word
      else
        summary << compozition
        compozition = word
      end
    end
    # Добавим последний кусочек текста в summary который не обработался в цикле each
    summary << compozition
    # Уберем лишний пробел в начале
    summary.first[0] = ""

    return summary.join("\n")
  end
end
