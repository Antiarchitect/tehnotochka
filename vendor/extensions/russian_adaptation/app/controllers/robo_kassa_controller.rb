class RoboKassaController < Spree::BaseController
  before_filter :load_order_and_robo_kassa
  
  # TODO log results?
  def result
    if @robo_kassa.result?(params)
      render :text => "OK#{@order.number}", :status => :ok
    else
      render :text => "Signature is invalid", :status => :ok
    end
  end
 
  def success
    if @robo_kassa.success?(params)
      @order.checkout.payments.first.finalize!
      flash[:notice] = 'Платёж принят, спасибо!'
    else
      flash[:error] = 'Платёж не прошёл проверку подписи.'
    end
    redirect_to order_url(@order.number)
  end
  
  def fail
    flash[:error] = 'Платёж не завершен или отменён.'
    redirect_to order_url(@order.number)
  end

  private 

  def load_order_and_robo_kassa
    number = "R%.9d" % params[:InvId]
    @order = Order.find_by_number(number)
    @robo_kassa = Billing::RoboKassa.current.try(:provider)
    if !@robo_kassa
      flash[:error] = "Этот способ оплаты не активен."
    elsif !@order
      flash[:error] = "Заказ с номером #{number} не найден."
    elsif @order.paid?
      flash[:error] = "Заказ с номером #{number} уже оплачен."
    elsif !@order.checkout.complete?
      flash[:error] = "Заказ с номером #{number} еще не оформлен."
    elsif !@order.checkout.payments.detect{|p| p.payment_method.class.to_s == "Billing::RoboKassa"} # TODO p.payment_method.method_type == "robokassa"
      flash[:error] = "Заказ с номером #{number} не может быть оплачен этим способом."
    end
    redirect_to root_url if flash[:error]
  end
end
