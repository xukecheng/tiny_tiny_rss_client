<template>
  <view class="content">
    <view class="head">
      <view class="title">{{ article.title }}</view>
      <view class="feed_title">{{ article.feed_title }}</view>
    </view>
    <view class="detail">
      <u-parse
        :html="article.content"
        :tag-style="tagStyle"
        :use-cache="true"
        :lazy-load="true"
        :loading-img="loading_img"
      ></u-parse>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      url: process.env.VUE_APP_URL,
      loading_img: "https://oktools.net/ph/750x350?t=Loading",
      article: "",
      tagStyle: {
        p: "margin: 30rpx 0; text-align: justify; word-break: break-all;",
        h3: "margin-top: 60rpx",
        h2: "margin-top: 60rpx",
        h1: "margin-top: 60rpx",
        img: "margin: 10rpx 0;",
        a:
          "color: #607fa6; cursor: pointer; text-decoration: none; border-bottom: 1px solid #607fa6; word-wrap: break-word; word-break: break-all;",
      },
    };
  },

  onLoad(option) {
    uni.showLoading({title: "加载中...", mask: true})
    const { id } = option;
    this.getLocalDetail(id);
    uni.hideLoading()
    uni.request({
      url: this.url + `/mark_read?id=${id}`,
      method: "GET",
    });
  },

  methods: {
    getLocalDetail(article_id) {
      const article_detail = uni.getStorageSync("article_details");
      if (article_detail && article_detail[article_id]) {
        this.article = article_detail[article_id];
      } else {
        this.getWebDetail(article_id);
      }
    },
    getWebDetail(article_id) {
      uni.request({
        url: this.url + `/article_detail?id=${article_id}`,
        method: "GET",
        success: (res) => {
          const { data } = res.data;
          const article_detail = uni.getStorageSync("article_details");
          if (article_detail) {
            article_detail[data.id] = data;
            uni.setStorageSync("article_details", article_detail);
            this.article = data;
          } else {
            const article_detail = {};
            article_detail[data.id] = data;
            uni.setStorageSync("article_details", article_detail);
            this.article = data;
          }
        },
      });
    },
  },
};
</script>

<style>
.content {
  padding: 0 32rpx;
}

.title {
  margin-top: 30rpx;
  font-size: 36rpx;
  color: black;
  font-weight: bold;
}

.feed_title {
  font-size: 28rpx;
  margin-top: 20rpx;
  color: #1e4b8d;
}

.detail {
  font-size: 30rpx;
  line-height: 1.6;
  overflow: hidden;
  margin-top: 30rpx;
}
</style>
