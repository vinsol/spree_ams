module Spree
  module Api
    module Ams
      class OrdersController < Spree::Api::V1::OrdersController
        include Serializable
        include Requestable

        def mine
          super
          respond_with @orders
        end

        private

          def order_id
            super || params[:id]
          end
      end
    end
  end
end
