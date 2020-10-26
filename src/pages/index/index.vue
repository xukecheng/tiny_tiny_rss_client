<template>
	<view class="content">
    <u-card
      :key="index"
      v-for="(article, index) of articles.list"
      :title="article.feed_title"
      :sub-title="article.time"
      :thumb="article.feed_icon"
      thumb-width="30"
      title-size="24rpx"
      :style="{'background-color': (article.is_read ? '#f7f7f7':'white')}"
      @click="toDetail(article.id)"
      >
      <view class="u-body-item u-flex u-col-between u-p-t-0" slot="body">
        <view class="" >
          <view class="u-body-item-title u-line-2">{{article.title}}</view>
          <text class="article_describtion"
            v-if="article.description=='&hellip;' ? true : false"
          >
          {{article.description}}
          </text>
          <image
            :src="article.flavor_image"
            mode="aspectFill"
            v-if="article.flavor_image ? true : false"
          >
          </image>
        </view>
      </view>
    </u-card>
	</view>
</template>

<script>
  import htmlToText from 'html-to-text'

	export default {
		data() {
			return {
        isReadBodyStyle: {
          "background-color": "#f7f7f7",
        },
        isReadHeadStyle: {
          "background-color": "#f7f7f7",
          "border-bottom-color": "rgb(228, 231, 237)",
          "border-bottom-style": "solid",
          "border-bottom-width": "1px"
        },
        Style: {
          "background-color": "white",
        },
        articles: {
          list: []
        }
			}
    },
    
		onLoad() {
      this.haveSubscribe()
      this.getFeeds()
      this.getArticles()
      this.getRead()
      this.articleSync()
    },

    onShow() {
      this.getRead()
    },

    onPullDownRefresh() {
      this.getArticles()
      this.getRead()
      this.articleSync()
    },

		methods: {
      getRead() {
        try {
          const is_read_list = uni.getStorageSync('is_read_list')
          for (var index in this.articles.list) {
            if (is_read_list.indexOf(this.articles.list[index].id) > -1) {
              this.$set(this.articles.list[index], 'is_read', true)
            } else {
              this.$set(this.articles.list[index], 'is_read', false)
            }
          }
        } catch (e) {
          pass
        }
      },
			haveSubscribe () {
				uni.getStorage({
					key: 'ttrss',
					success: function (res) {
						console.log(res.data);
					},
					fail: function (res) {
						uni.showModal({
                title: '没有任何信息',
                content: '是否登录',
                success: function (res) {
                  if (res.confirm) {
                    uni.setStorage({
                      key: 'ttrss',
                      data: {
                        url: 'test',
                        username: 'test',
                        password: 'test'
                      }
                    })
                  }
                }
						});
					}
				})
      },
      getFeeds () {
        uni.request({
          url: 'http://localhost:8888/get_feeds',
          method: 'GET',
          success: (res => {
            const {data} =  res.data
            uni.setStorageSync("feeds", data)
          })
        })
      },
      getArticles () {
        console.log(process.env.BASE_URL)
        uni.request({
          url: 'http://localhost:8888/get_unreads',
          method: 'GET',
          success: (res => {
            const {data} =  res.data
            const feeds = uni.getStorageSync('feeds')
            for (var index in data) {
              const description = htmlToText.fromString(data[index].description, {
                wordwrap: 130
              })
              data[index].description = description
              const id = data[index].feed_id
              data[index]["feed_icon"] = feeds[id].feed_icon
            }
            uni.setStorageSync("articles", data)
          })
        })
      },
      articleSync () {
        const data = uni.getStorageSync('articles')
        this.articles.list = data
      },
      toDetail(id) {
        try {
          const is_read_list = uni.getStorageSync('is_read_list')
          if(is_read_list.indexOf(id) == -1) {
            is_read_list.push(id)
          }              
          uni.setStorageSync('is_read_list', is_read_list);
        } catch (e) {
          uni.setStorageSync('is_read_list', [id]);
        }
        uni.navigateTo({
            url: `/pages/index/detail?id=${id}`
        })
      },


		}
	}
</script>

<style>
	.content {
		display: flex;
		flex-direction: column;
		justify-content: center;
		background-color: white;
	}

  .u-card-wrap { 
		background-color: $u-bg-color;
		padding: 2rpx;
	}
	
	.u-body-item {
		font-size: 32rpx;
		color: #333;
	}
  
  .u-body-item image {
		flex: 0 0 120rpx;
		border-radius: 8rpx;
    margin-top: 12rpx;
    max-height: 240rpx;
  }

  .article_describtion_is_read {
    background-color: #f7f7f7;
  }

  .article_describtion {
		font-size: 28rpx;
    line-height: 38rpx;
		color: #8f8f94;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
    overflow: hidden;
    margin-top: 20rpx;
  }
</style>
