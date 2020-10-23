<template>
    <view class="content">
      <view class="head">
        <view class="title">{{article.title}}</view>
        <view class="feed_title">{{article.feed_title}}</view>
      </view>
      <view class="detail">
        <jyf-parser 
          :html="article.content"
          :tag-style="tagStyle"
          :use-cache="true"
          :lazy-load="true"
          :loading-img="loading_img"
        ></jyf-parser>
      </view>
    </view>
</template>

<script>
import jyfParser from "@/components/jyf-parser/jyf-parser";

export default {
    components: {
      jyfParser
    },
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
      this.getDetail(id)
    },

    methods: {
      getDetail(article_id) {
        uni.request({
          url: `http://localhost:8888/article_detail?id=${article_id}`, //仅为示例，并非真实接口地址。
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
    /* padding: 40rpx 32rpx 20rpx; */
    /* font-size: 32rpx;
    line-height: 1.6;
    width: 100%; */
    font-size: 30rpx;
    line-height: 1.6;
    overflow: hidden;
    margin-top: 30rpx;
  }
</style>