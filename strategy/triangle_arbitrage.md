# 三角套利

## 交易标的

假设三币对：

* ETH|USDT
* EOS|USDT
* EOS|ETH

## 交易逻辑

令当前报价为：a = ETH|USDT, b = EOS|USDT, c = EOS|ETH

* 若 a * c / b > 1

    此时的情形相当于ETH相对于EOS价格过高，我们的思路是将手上的EOS兑换成ETH，然后将ETH抛出换成USDT，最后使用USDT买回之前抛出的等额EOS。具体操作手法如下，假设每次投入等额1USD，以下操作都不考虑交易成本：

    * 将全部USDT换购成EOS，获得 1/b 个EOS；

    * 将所有EOS换成ETH，获得 c/b 个ETH；

    * 将所有的ETH兑换为USDT，获得 a*c/b 个USDT；

    * 最终的获利为 (a*c/b - 1) 个USDT。


* 若 a * c / b < 1

    此时的情形相当于EOS相对月ETH价格过高，我们的思路是将手上的ETH兑换成EOS，然后将EOS抛出换成USDT，最后使用USDT买回之前抛出的等额ETH。具体操作手法如下

    * 将全部USDT换购成ETH，获得 1/a 个ETH；

    * 将所有ETH换成EOS，获得 1/(a*c) 个EOS；

    * 将所有的EOS兑换为USDT，获得 b/(a*c) 个USDT；

    * 最终的获利为 (b/(a*c) - 1) 个USDT。

## 可能的操作注意事项

上面的操作流程是在没有ETH和EOS底仓的情况下，必须从USDT购币作为发起。假如有ETH和EOS底仓的情况下，建议优先进行低流动性币对的交易。
