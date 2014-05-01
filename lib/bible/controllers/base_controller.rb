require 'erb'

module Bible
  class BaseController

    private

    def render view
      variables = self.instance_variables.inject({}){|a,v| a[v] = self.instance_variable_get(v) ;a }
      Renderer.new(variables).render(view)
    end
  end



  class View
    def initialize variables
      variables.each do |var_name, value|
        self.instance_variable_set var_name, value
      end
    end
  end

  class Renderer
    attr_accessor :variables

    def initialize variables
      self.variables = variables
    end

    def render view
      filename = "./lib/bible/views/#{view}.txt.erb"

      erb = ERB.new(File.read(filename), nil, '%')
      erb.def_class(View, 'render()').new(variables).render
    end
  end
end
