# SMLでカリー化入門


## 参考記事

- 食べられないほうのカリー化入門

http://qiita.com/KDKTN/items/6a27c0e8efa66b1f7799


## カリー化とは

カリー化とは、僕も大好きなカレーから...ではなく関数型プログラミングの雄、Haskell Curryさんからとられてます。名前からしておっ、となるようにあの関数型言語Haskellも彼の名前に由来しているようです（知らなかった！）



関数型言語は引数がひとつ。-> じゃあ複数の引数をどうやって渡す？

- SMLで複数の引数を可能とする方法

1. 組みを使う
2. カリー化関数

複数の引数 -> "最初の引数を引数"として"二つ目以降の引数を引数とする関数"を返す
**多層化することで引数をひとつずつ渡せる！！！**




### カリー化関数の型について

例えば以下のように組みで渡す場合は、この関数の型は`fn: int*(int -> int)`になる。

```
- fun plus (x,y) = x + y;
val plus = fn : int * int -> int
```

しかしここでカリー化した関数を宣言した場合、この関数の型は`fn: int->int->int`とそれぞれx->y->返り値と対応するような型になる。

```
- fun plusc x y = x + y;
val plusc = fn : int -> int -> int
```

>『2引数以上の関数を、1引数の関数の定義だけで同じ機能を持つように定義を書き換えること』を カリー化といいます
http://qiita.com/KDKTN/items/6a27c0e8efa66b1f7799

という説明が非常に分かりやすい。

他言語でのカリー化は参照ページを参考にしてほしいのですが、SMLではこのカリー化を簡単に実現する方法を提供してくれてる、という認識でいいと思う。



### カリー化関数でしか実現できないプログラム

以下は、**1と何かをたす関数**となる。

````
- val A1 plusc 1;

- A1 2;
val it = 3 : int
- A1 4;
val it = 5 : int
```

このように、カリー化関数は**部分的に具体化する関数**を定義することができる。

この場合、組みで渡す場合が要素数が必ず2こないといけないのに対し、カリー化することによって、要素数1の場合はこちらを実行するようにすれば万事解決！というように使うことができる。


>カリー化された関数に引数を渡すだけで、べつの機能を持つ関数を簡単に作り出せる
http://qiita.com/KDKTN/items/6a27c0e8efa66b1f7799

ということで、僕の説明より常に参照先ページの説明の方が分かりやすい！！笑


### 他の例

以下のようなmap関数があるとする。

```
fun simpleMap (F, nil) = nil
  | simpleMap (F, x::xs) = F(x)::simpleMap(F, xs);
```

これをカリー化して書くと、以下のように書けます。

```
fun simpleMapC F nil = nil
  | simpleMapC F x::xs = F x :: simpleMapC F xs;
```


mapは、ある一つの要素に対してなんらかの処理を行う関数`f`を第一引数に、組Lを第二引数に渡すことで、Lの全ての要素に対して`f`の処理を適用する、のような使い方ができる関数です。そしてSMLの組み込み関数mapは実は以下のような感じになってます。

```
fun map F = 
  let 
    fun M nil = nil
      | M (x::xs) = F x :: M xs
  in 
    M 
  end;
```

じゃあこの組み込み関数mapの型を調べてみる。組み込み関数の型を知るためには以下のようにすればよいです。

```
- map;
val it = fn : ('a -> 'b) -> 'a list -> 'b list
```


例えば、以下のようにして実行します。


```
- val L = [1.0, 1.4, 3.6];
val L = [1.0,1.4,3.6] : real list
- fun double x = x * 2.0;
val double = fn : real -> real
- map double L;
val it = [2.0,2.8,7.2] : real list`
```
