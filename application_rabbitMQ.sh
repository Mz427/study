###################################################################################################
#
###################################################################################################
Producer:                              Message1 Message2 Message3
                                          |        |        |
                                          |        |        |
Broker:                                   |        |        |
    Virtual Host:                         |        |        |
        Exchange(direct/fanout/topic):    |        |        |
            Bindings:                     |        |        |
            Queues:                    Queues1 Queues2 Queues3
                                          |        |        |
                                          |        |        |
Consumer:                              Message1 Message2 Message3

port:
    4369(epmd), 25672(Erlang distribution)
    5672, 5671(AMQP 0-9-1 without and with TLS)
    15672 (web management)
    61613, 61614(STOMP)
    1883, 8883(MQTT)
