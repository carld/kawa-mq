(import (class
          com.rabbitmq.client
          ConnectionFactory
          Connection
          Channel
          Consumer
          DefaultConsumer))

(define factory (ConnectionFactory))
(factory:setHost "localhost")

(define connection (factory:newConnection))
(define channel (connection:createChannel))

(channel:queueDeclare "hello" #f #f #f #!null)
(format #t " [*] Waiting for messages. To exit press CTRL+C~%")

(define-simple-class HelloConsumer (<com.rabbitmq.client.DefaultConsumer>)
          ; DefaultConsumer does not have a default constructor
          ((*init* (channel ::Channel))
           (invoke-special DefaultConsumer (this) '*init* channel))
          ; Kawa can infer parameter and return types of a method that overrides
          ; a method in a super-class.
          ((handleDelivery consumerTag
                           envelope
                           properties
                           body)
              (let ((message (String body "UTF-8")))
                (format #t " [x] Received '~a'~%~!" message))))

(define consumer (HelloConsumer channel))

(channel:basicConsume "hello" #t consumer )

