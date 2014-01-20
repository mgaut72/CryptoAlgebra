---
layout: page
title: Welcome to CryptoAlgebra!
tagline: Supporting tagline
---
{% include JB/setup %}

This blog will follow my journey through the "Introduction to Cryptography"
and "Second Course in Abstract Algebra" classes at the University of Arizona.

Since abstract algebra (specifically ring theory) has applications in
cryptography, I plan on talking about
the crypto-algorithms I learn in class, and some of the theory behind them.

Code examples will be available in Haskell, since the math-y foundations of
Haskell play very nicely with algebra; and more importantly, why not?

[Find out more about me here]({{BASE_PATH}}/about.html)

<h2 class="noline"><a href="{{BASE_PATH}}/posts.html">All Posts</a></h2>

## Recent Posts

<ul class="posts">
  {% for post in site.posts limit:10%}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>


