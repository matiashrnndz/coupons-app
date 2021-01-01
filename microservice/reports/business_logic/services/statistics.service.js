var amqp = require('amqplib/callback_api');
const promoStatLogic = require('../../business_logic/promo_stats.logic');

async function receiveEvaluations(){

  amqp.connect('amqp://vzqgravf:6hFEvBEiAFDsmTW1oE8OKatfU_tHuzr7@wasp.rmq.cloudamqp.com/vzqgravf', function (err, conn) {
      conn.createChannel(function (err, channel) {
        var exchange = 'evaluation';
        channel.assertExchange(exchange, 'fanout', { durable: false });
        channel.assertQueue('', { exclusive: true }, function (err, q) {
          //console.log(" [*] Waiting for messages in %s. To exit press CTRL+C", q.queue);

          channel.bindQueue(q.queue, exchange, '');
          channel.consume(q.queue, function (msg) {
            console.log(" [x] %s", msg.content.toString());
            var obj=JSON.parse( msg.content.toString())
            console.log(obj);
            
            promoStatLogic.processStatistic(obj);

          }, { noAck: true });
        });
      });
      //setTimeout(function () { conn.close(); process.exit(0) }, 60000);
  })
}

module.exports.receiveEvaluations = receiveEvaluations;