<template>
	<view class="content">
    <uni-list>
      <uni-list-item 
        clickable
        :key="index"
        v-for="(article, index) of articles.list"
        @click="toDetail(article.id)"
        :class="[article.is_read ? 'is_read' : 'list']"
      >
        <view slot="body" class="list__content">
          <view class="list__title">{{article.title}}</view>
          <text class="list__feed_title">{{article.feed_title}}</text>
          <text class="list__describtion">{{article.description}}</text>
        </view>
      </uni-list-item>
    </uni-list>
	</view>
</template>

<script>
  import htmlToText from 'html-to-text'

	export default {
    components: {uniList,uniListItem,uniListChat},
		data() {
			return {
        articles: {
          list: []
        }
			}
    },
    
		onLoad() {
      this.haveSubscribe()
      this.getFeed()
    },

    onShow() {
      this.getRead()
    },

    onPullDownRefresh() {
      this.getFeed()
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
      getFeed () {
        uni.request({
          url: process.env.API_URL + '/get_unreads',
          method: 'GET',
          success: (res => {
            const {data} =  res.data
            for (var index in data) {
              const description = htmlToText.fromString(data[index].description, {
                wordwrap: 130
              })
              data[index].description = description
            }
            this.articles.list = data
          })
        })
      },
      toDetail(id) {
        uni.request({
          url: process.env.API_URL + `/mark_read${id}`,
          method: 'GET',
          success: (res => {
            try {
              const is_read_list = uni.getStorageSync('is_read_list')
              if(is_read_list.indexOf(id) == -1) {
                is_read_list.push(id)
              }              
              uni.setStorageSync('is_read_list', is_read_list);
            } catch (e) {
              uni.setStorageSync('is_read_list', [id]);
            }
          })
        })
        uni.navigateTo({
            url: `/pages/index/detail?id=${id}`
        })
      }

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

	.list__content {
		position: relative;
	}

  .list {
    background-color: white;
  }

  .is_read {
    background-color: #f7f7f7;
  }

	.list__title {
		font-size: 36rpx;
    line-height: 46rpx;
    margin-bottom: 20rpx;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
    overflow: hidden;
	}

  .list__feed_title {
    font-size: 28rpx;
    color: #1e4b8d;
  }

  .list__describtion {
		font-size: 28rpx;
    line-height: 38rpx;
		color: #8f8f94;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
    overflow: hidden;
    margin-top: 10rpx;
  }

  .list__image {
    width: 100rpx;
    height: auto;
    position: relative;
  }
</style>
