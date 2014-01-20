---
layout: post
title: Establishing Some Conventions
tags: [Getting Started, Classical Cryptosystems]
---

For these classical cryptosystems, we need to establish a few conventions before
we get down the the real work.

## Numerical Representation

We will establish the following mapping from characters to integers:

$$
\begin{array}{c c c c}
 a & b & c & d & \cdots & z \\\\
 \downarrow & \downarrow & \downarrow & \downarrow & \cdots & \downarrow \\\\
 0 & 1 & 2 & 3 & \cdots & 25 \\\\
 \end{array}
$$


To follow this convention I will use the following functions:
{% highlight haskell %}
import Data.Char (toUpper)

charToAlphaIdx :: Char -> Int
charToAlphaIdx = subtract 65 . fromEnum . toUpper

alphaIdxToChar :: Int -> Char
alphaIdxToChar = toEnum . (+ 65)
{% endhighlight %}
The functions `toEnum` and `fromEnum` will convert between characters and ascii values.
I chose to convert to uppercase quite arbitrarily, and we could have just
as well used `toLower` along with 97 (ascii 'a') rather than 65 (ascii 'A')
to zero our indexing.


## Plaintext vs. Ciphertext

We will make the convention that plaintext (in our case, strings in plain
english), will be represented as all lowercase characters.  It follows then
that we make ciphertext (text that has been encrypted) all capitol letters.

{% highlight haskell %}
ghci> encrypt "plaintext"
"CIPHERTEXT"
{% endhighlight %}

## Cleaning Input

It is common practice for plaintext to be stripped of spaces, punctuation,
numbers, etc.  This is done partly for historical reasons, and partly for
simplicity.  When attempting to hand-crack a cipher, it is much more difficult
to crack ciphertext with no spaces, as you cannot use word and sentence
structure to your advantage.

So we will use a function for cleaning plaintext before encryption:
{% highlight haskell %}
import Data.Char (isAlpha)

clean :: String -> String
clean = filter isAlpha
{% endhighlight %}
