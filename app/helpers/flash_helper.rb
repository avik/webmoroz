module FlashHelper

  def bootswatch_flash(alert_dismissable=true)
    alert_dismissable_class = alert_dismissable ? ' alert-dismissable' : ''
    flash_messages = ''
    puts flash.to_yaml
    flash.each do |type, message|
      alert_type_class = bootswatch_alert_types(type)
      if message.is_a?(Array)
        message.map!{|msg| content_tag(:li,msg)}
        message = content_tag(:ul, raw(message.join))
      end
      if alert_dismissable
      alert_div = content_tag(:div, raw('<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>') + raw(message), :class => "alert #{alert_type_class}#{alert_dismissable_class}")
      else
        alert_div = content_tag(:div, raw(message), :class => "alert #{alert_type_class}")
      end
      flash_messages << alert_div if message
    end
    raw(flash_messages)
  end

end
