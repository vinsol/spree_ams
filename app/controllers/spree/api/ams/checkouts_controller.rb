module Spree
  module Api
    module Ams
      class CheckoutsController < Spree::Api::V1::CheckoutsController
        include Serializable
        include Requestable

        def back_to_state
          @order = Spree::Order.lock(true).find_by!(number: params[:id])
          authorize! :update, @order, order_token

          if @order.completed?
            render json: {
              error: 'Cannot perform this action on completed order'
            }, status: 422
          elsif order_states.exclude? params[:state]
            render json: {
              error: 'Requested state is invalid'
            }, status: 422
          elsif order_states.index(params[:state]) > order_states.index(@order.state)
            render json: {
              error: "Cannot transition from #{@order.state} to #{params[:state]}"
            }, status: 422
          else
            @order.update_column(:state, params[:state])
            state_callback(:before)
            respond_with(@order)
          end
        end

        private

        def order_id
          super || params[:id]
        end

        def order_states
          ['cart'] + @order.checkout_steps
        end
      end
    end
  end
end
