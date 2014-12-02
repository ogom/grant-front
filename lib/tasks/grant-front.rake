namespace :grant_front do
  desc 'Draws Authorization Grant Roles'
  task :draw do
    GrantFront::Grant.draw
  end
end
