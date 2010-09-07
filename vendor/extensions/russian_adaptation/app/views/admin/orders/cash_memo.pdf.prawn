# -*- coding: utf-8 -*-
# TODO !!!
font_directory = "#{RussianAdaptationExtension.root}/public/images/fonts"
pdf.font_families.update("Arial" => { :bold => "#{font_directory}/arialbd.ttf",
                                      :italic => "#{font_directory}/ariali.ttf",
                                      :bold_italic => "#{font_directory}/arialbi.ttf",
                                      :normal => "#{font_directory}/arial.ttf" })
pdf.font "Arial"

@order = @object
ship_address = @order.ship_address

pdf.image "#{RussianAdaptationExtension.root}/public/images/bw_logo_check.png",
:at => [pdf.bounds.left, pdf.bounds.top], :fit => [100, 65]
pdf.text 'ИП "Воронков Андрей Алексеевич" ИНН 280105543265 ОГРНИП 310280119300071',
:size => 7, :align => :right
###################################
# Шапка
###################################
pdf.move_down 20
pdf.text "#{I18n::t('cash_memo')} №#{@order.number} от #{@order.created_at.strftime("%d.%m.%Y")} г.",
:align => :right,
:style => :bold,
:size => 16

# pdf.text_box "#{Date.today}",
# :width    => 50,
# :height => pdf.font.height * 2,
# :overflow => :ellipses,
# :at       => [pdf.bounds.right-100,pdf.bounds.top-10],
# :align => :right

pdf.move_down 30
# pdf.text "#{Date.today}"
# pdf.move_down 5
pdf.text "От кого: #{RUSSIAN_SETTINGS['finance']['company_name']}", :size => 10
pdf.move_down 5
pdf.text "Получатель: #{ship_address.firstname} #{ship_address.lastname}", :size => 10
pdf.move_down 15

###################################
# Таблица товаров
###################################
order_items = [[]]
i = 0
@order.line_items.each do |item|
  order_items[i] = [item.variant.product.name, # + (item.variant.option_values.empty? ? '' : ("(" + variant_options(item.variant) + ")")),
                    number_to_currency(item.price).gsub('&nbsp;', ' '),
                    item.quantity,
                    number_to_currency(item.price * item.quantity).gsub('&nbsp;', ' ')
                   ]
  i += 1
end

@order.adjustments.each do |adjustment|
  order_items[i] = [adjustment.description,
                    '',
                    '',
                    number_to_currency(adjustment.amount).gsub('&nbsp;', ' ')
                   ]
  i += 1
end

order_items[i] = ["ИТОГОВАЯ СТОИМОСТЬ", "", "", number_to_currency(@order.total).gsub('&nbsp;', ' ')]

pdf.table order_items,
:headers  => ["Наименование", "Цена", "Кол-во", "Сумма"],
:position => :center,
:border_width => 1,
:border_style => :grid,
:font_size => 10,
:column_widths => { 0 => 300, 1 => 80, 2 => 80, 3 => 80 }

###################################
# Подвал
###################################
pdf.move_down 30
pdf.text "Итого: #{number_to_currency(@order.total).gsub('&nbsp;', ' ')}",
:size => 13,
:style => :bold,
:align => :right
pdf.move_down 30
pdf.text "М.П.",
:size => 13,
:align => :center