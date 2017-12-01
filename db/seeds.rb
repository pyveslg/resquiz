# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "open-uri"
require "json"
require "yaml"

CLIENT_ID = ENV['GH_BASIC_CLIENT_ID']
CLIENT_SECRET = ENV['GH_BASIC_SECRET_ID']

url= "https://api.github.com/repos/pyveslg/MFE/contents/quizzes?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}"

Answer.destroy_all
Option.destroy_all
Question.destroy_all
Quiz.destroy_all


fetch_ymls= open(url).read
ymls = JSON.parse(fetch_ymls)
ymls.each_with_index do |yml, i|
  quizz_url = ymls[i]['download_url']
  quizz_content = open(quizz_url).read
  quizz = YAML.load(quizz_content)


  quiz = Quiz.create!
  quiz.slug = quizz["slug"]
  quiz.name = quizz["name"]
  quiz.path = quizz["path"]
  quiz.save!

  quizz["questions"].each do |question|
      new_question = Question.create(:quiz_id => quiz.id)
      new_question.name = question["name"]
      new_question.save

      question["options"].each do |option|
        option["question_id"] = new_question.id
        Option.create!(option)
      end
  end
end
puts "Finished"
