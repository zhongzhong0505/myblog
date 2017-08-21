    <script src='//git.oschina.net/zt_zhong/CodeBe/widget_preview'></script>

<style>
.pro_name a{color: #4183c4;}
.osc_git_title{background-color: #fff;}
.osc_git_box{background-color: #fff;}
.osc_git_box{border-color: #E3E9ED;}
.osc_git_info{color: #666;}
.osc_git_main a{color: #9B9B9B;}
</style>

{% if theme.comments.enable %}
    <i id="com-switch" class="iconfont icon-more syuanpi jumping-in long infinite" style="font-size:24px;display:block;text-align:center;"></i>
    <div class="post-comments" id="post-comments" style="margin: auto 16px;">
        {% include "../../_script/_comment/uyan.swig" %}
        {% include "../../_script/_comment/duoshuo.swig" %}
        {% include "../../_script/_comment/netease.swig" %}
        {% include "../../_script/_comment/disqus.swig" %}
    </div>
{% endif %}