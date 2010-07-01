class RussianAdaptationHooks < Spree::ThemeSupport::HookListener
  
  insert_after :inside_head do
    %(<link type="text/css" rel="stylesheet" media="screen" href="/stylesheets/screen.ext.css">)
  end
  
  insert_after :admin_inside_head do
    %(<%= javascript_include_tag :ckeditor %>) if defined?(Ckeditor)
  end

  insert_before :admin_order_show_buttons do
    %( <%= button_link_to(I18n::t("waybill"), waybill_admin_order_url(@order, :format => :pdf)) <<
           button_link_to(I18n::t("cash_memo"), cash_memo_admin_order_url(@order, :format => :pdf)) %>)
  end

  insert_before :admin_order_edit_buttons do
    %( <%= button_link_to(I18n::t("waybill"), waybill_admin_order_url(@order, :format => :pdf)) <<
           button_link_to(I18n::t("cash_memo"), cash_memo_admin_order_url(@order, :format => :pdf)) %>)
  end

  insert_after :order_details_total, 'orders/payment_links'
end
