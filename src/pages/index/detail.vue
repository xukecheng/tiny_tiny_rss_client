<template>
    <view class="content">
      <view class="head">
        <view class="title">{{article.title}}</view>
        <view class="feed_title">{{article.feed_title}}</view>
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
        loading_img: "https://oktools.net/ph/750x350?t=Loading",
        article: "",
        tagStyle: {
          p: "margin: 30rpx 0; text-align: justify;",
          h3: "margin-top: 60rpx",
          h2: "margin-top: 60rpx",
          h1: "margin-top: 60rpx",
          img: "margin: 10rpx 0;",
          a: "color: #607fa6; cursor: pointer; text-decoration: none; border-bottom: 1px solid #607fa6; word-wrap: break-word; word-break: break-all;"
        }
			}
    },

		onLoad(option) {
      const {id} = option
      uni.request({
        url: `http://localhost:8888/mark_read?id=${id}`,
        method: 'GET',
        success: (res => {
          this.getDetail(id)
        })
      })
    },

    methods: {
      getDetail(article_id) {
        uni.request({
          url: `http://localhost:8888/article_detail?id=${article_id}`,
          method: 'GET',
          success: (res => {
            const {data} =  res.data
            this.article = data
          })
        })
      }
    }
}
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