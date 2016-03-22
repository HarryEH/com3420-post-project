class PagesController < ApplicationController
  
  def home
    @current_nav_identifier = :home
  end

  def map
    @current_nav_identifier = :map
  end
  
  def about
    @current_nav_identifier = :about
  end  
  
  def modpanel
  end

  #fetch list of mods with ActiveRecord query
  #stored as ActiveRecord relation (collection of objects)
  def modlist
    @mods = Mod.all
  end
  
end
