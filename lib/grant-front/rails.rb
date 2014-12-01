module GrantFront
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/grant-front.rake'
    end
  end
end
