---
title: Choeur Together
permalink: /
---

{% capture qui-sommes-nous %}{% include qui-sommes-nous.md %}{% endcapture %}
{% capture notre-histoire %}{% include notre-histoire.md %}{% endcapture %}
{% capture rejoins-nous %}{% include rejoins-nous.md %}{% endcapture %}
{% capture contact %}{% include contact.md %}{% endcapture %}

<div id="qui-sommes-nous" class="chapter">
  <div class="section">
  {{ qui-sommes-nous | markdownify }}
  </div>
</div>

<div id="notre-histoire" class="chapter">
  <div class="section">
  {{ notre-histoire | markdownify }}
  </div>
</div>

<div id="rejoins-nous" class="chapter">
  <div class="section">
  {{ rejoins-nous | markdownify }}
  </div>
</div>

<div id="contact" class="chapter">
  <div class="section">
  {{ contact | markdownify }}
  </div>
</div>
