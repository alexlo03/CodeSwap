module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def faculty_count
    User.where(:role => :faculty).count
  end
  def admin_count
    User.where(:role => :admin).count
  end
  def ta_count
    User.where(:role => :ta).count
  end
  def student_count
    User.where(:role => :student).count
  end
end
