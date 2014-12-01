namespace :grant_front do
  desc 'Draws Authorization Grant Roles'
  task :draw do
    puts '| class | method | roles |'
    puts '|:-----:|:------:|:-----:|'
    GrantFront.draw.each do |policy|
      puts "| #{policy[:class]} | #{policy[:method]} | #{policy[:roles].join(',')} |"
    end
  end
end
