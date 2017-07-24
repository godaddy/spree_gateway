module Spree
  CheckoutController.class_eval do
    before_filter :confirm_skrill, :only => [:update]

    def skrill_cancel
      flash[:error] = Spree.t(:payment_has_been_cancelled)
      redirect_to edit_order_path(@order)
    end

    private
    def confirm_skrill
      return unless (params[:state] == "payment") && params[:order][:payments_attributes]

      payment_method = PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
      if payment_method.kind_of?(BillingIntegration::Skrill::QuickCheckout)
        #TODO confirming payment method
        redirect_to edit_order_checkout_url(@order, :state => 'payment'),
                    :notice => Spree.t(:complete_skrill_checkout)
      end
    end
  end
end
