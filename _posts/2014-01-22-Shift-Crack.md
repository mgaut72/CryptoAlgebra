---
layout: post
title: Cracking the Shift Cipher
category: Classical-Cryptosystems
tags: [cracking]
---

Last time we learned how to use the Shift Cipher.
View [the Shift Cipher post]({% post_url 2014-01-21-Shift-Cipher %}) if you
want to know what is going on.

## English Letter Frequencies

Frequencies of letters in common english are as follows:
{% highlight haskell %}
ghci> :l CryptoTools.hs
ghci> zip ['A' .. 'Z'] englishFrequencies
[('A',8.2e-2),('B',1.5e-2),('C',2.8e-2),('D',4.3e-2),('E',0.127)
,('F',2.2e-2),('G',2.0e-2),('H',6.1e-2),('I',7.0e-2),('J',2.0e-3)
,('K',8.0e-3),('L',4.0e-2),('M',2.4e-2),('N',6.7e-2),('O',7.5e-2)
,('P',1.9e-2),('Q',1.0e-3),('R',6.0e-2),('S',6.3e-2),('T',9.1e-2)
,('U',2.8e-2),('V',1.0e-2),('W',2.3e-2),('X',1.0e-3),('Y',2.0e-2)
,('Z',1.0e-3)]
{% endhighlight %}

The `englishFrequencies` list can be made by simply searching the internet.
This information will be useful later on, so I copied into a `[Double]`

As you can see, 'E' is the most common letter.  We will use this information
in order to decode ciphertext that has been encrypted by the Shift Cipher,
   even if we do not know the key.

## Time to Crack the Shift Cipher

If we encrypt a large enough chunk of english text with the Shift Cipher,
the frequencies of each letter will in the ciphertext will be shifted from
the plaintext.  This is useful because all we have to do is determine what the
most common letter is in our ciphertext.  One we know that, we can assume the
encryption process mapped 'e' to that most common letter, and can compute the
key from that difference.

#### First, find the frequency of ciphertext characters
{% highlight haskell %}
--file : CryptoTools.hs

letterFreq :: String -> [Double]
letterFreq s = [ normalize . countC c $ (map toUpper s) | c <- ['A'..'Z']]
    where countC c = length . filter (== c)
          normalize = (/ fromIntegral (length s)) . fromIntegral
{% endhighlight %}

For each letter of the alphabet $ c $, we are filtering out
everthing not equal to $ c $ in the input text, and counting the length
of the remaining list.  Then we normalize by dividing by the total length.

#### Second, find the index (character) which contains the maximum frequency in our frequency list.

{% highlight haskell %}
-- interim code, to be combined later

maxIndex xs = snd . maximum $ zip xs [0 .. ]
{% endhighlight %}

First we make a list of tuples, `(frequency, index)`.
`maximum` then takes the max of the list,
  which compares based on `frequecy` first, then based
  on `index`. `snd` then gives us the `index` contained within the tuple,
  and we are done!

#### Third, Determine the difference in the index of the most common ciphertext character with that of 'e', yeilding the key

{% highlight haskell %}
-- interim code, to be combined later

key = maxIndex (letterFreq cs) - (charToIdx 'e')
{% endhighlight %}


### The Cracking Function

Now we simply need to combine the results of 1. - 3. to get our final function:

{% highlight haskell %}
-- file : ShiftCrack.hs
import CryptoTools
import Shift

shift_crack :: String -> String
shift_crack cs = shift_decrypt key cs
    where key = maxIndex (letterFreq cs) - (charToIdx 'e')
          maxIndex xs = snd . maximum $ zip xs [0 .. ]
{% endhighlight %}

## Requirements for success

So this is a pretty neat way to crack the Shift Cipher, but be careful.  It
will only work when you have text that has 'e' as the most common letter.
Often this is the case, but with short text, or intentionally deceitful text
you are out of luck.

If you are only intercepting short messages, believed to be encrypted with the
same key, you could combine messages to get a reasonable sample size.  However
it is possible that each message is encrypted with a different key.

Finally, this encryption method can easily be brute forced.  There are exactly
25 unique keys, that actually encrypt the message (0 doesn't do anything);
though it would require more sophisticated language processing in order
to programmatically determine if you have successfully cracked the message.
