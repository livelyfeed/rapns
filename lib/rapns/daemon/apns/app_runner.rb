module Rapns
  module Daemon
    module Apns
      class AppRunner < Rapns::Daemon::AppRunner
        ENVIRONMENTS = {
          :production => {
            :push     => ['gateway.push.apple.com', 2195],
            :feedback => ['feedback.push.apple.com', 2196]
          },
          :development => {
            :push      => ['gateway.sandbox.push.apple.com', 2195],
            :feedback  => ['feedback.sandbox.push.apple.com', 2196]
          }
        }

        protected

        def started
          poll = Rapns.config[:feedback_poll]
          host, port = environment[:feedback]
          @feedback_receiver = FeedbackReceiver.new(app, host, port, poll)
          @feedback_receiver.start
        end

        def stopped
          @feedback_receiver.stop if @feedback_receiver
        end

        def new_delivery_handler
          push_host, push_port = environment[:push]
          DeliveryHandler.new(app, push_host, push_port)
        end

        def environment
          @environment ||= ENVIRONMENTS[app.environment.to_sym]
        end
      end
    end
  end
end
