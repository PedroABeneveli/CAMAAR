# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the login\s?page$/
      '/users/sign_in'

    when /^the Avaliacoes\s?page$/
      '/avaliacoes'

    when /^the Gerenciamento\s?page$/
      '/gerenciamento'

    when /^the Resultados\s?page$/
      '/gerenciamento/resultados'

    when /^the Templates\s?page$/
      '/gerenciamento/templates'

    when /^the Send Forms\s?page$/
      '/gerenciamento/send_forms'

    when /^the Create Templates\s?page$/
      '/gerenciamento/templates/new'

    when /^the Edit Templates\s?page$/
      "/gerenciamento/templates/#{@template.id}/edit"

    when /^the Definir Senha\s?page$/
      "/users/password/edit?reset_password_token=#{@token}"

      # Add more mappings here.
      # Here is an example that pulls values out of the Regexp:
      #
      #   when /^(.*)'s profile page$/i
      #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
                "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)