module ApplicationHelper
  def user_avatar(user, size: 64, css_class: "")
    if user.profile_photo.attached?
      image_tag user.profile_photo.variant(resize_to_limit: [size, size]),
        class: "rounded-full object-cover #{css_class}",
        alt: "#{user.email.split("@").first}'s profile photo"
    else
      content_tag :div,
        user.email[0].upcase,
        class: "rounded-full flex items-center justify-center text-white font-bold #{css_class}",
        style: "background: linear-gradient(135deg, #10b981 0%, #14b8a6 100%);"
    end
  end
end
