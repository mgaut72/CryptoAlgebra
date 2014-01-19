---
layout: post
title: Establishing Some Conventions
tags: [Getting Started, Classical Cryptosystems]
---

For these classical cryptosystems, we need to establish a few conventions before
we get down the the real work.

### Numberical Representation

We will establish the following mapping from characters to integers:

$$
\begin{array}{c c c c}
 a & b & c & d & \cdots & z \\
 \downarrow & \downarrow & \downarrow & \downarrow & \cdots & \downarrow \\
 0 & 1 & 2 & 3 & \cdots & 25 \\
 \end{array}
$$

To follow this convention I will use the following functions:

{% highlight haskell %}
charToAlphaIdx :: Char -> Int
charToAlphaIdx = subtract 65 . fromEnum . toUpper

alphaIdxToChar :: Int -> Char
alphaIdxToChar = toEnum . (+ 65)
{% endhighlight %}


### Plaintext vs. Ciphertext

We will make the convention that plaintext (in our case, strings in plain
english), will be represented as all lowercase characters.  It follows then
that we make ciphertext (text that has been encrypted) all capitol letters.
