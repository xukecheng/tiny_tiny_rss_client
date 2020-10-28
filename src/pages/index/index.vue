<template>
  <view class="content">
   <Popup
      ref="Popup"
      :feed_tree="feed_tree.list"
      :feeds="feeds.list"
    />
    <u-card
      :key="index"
      v-for="(article, index) of articles.list"
      :style="{ 'background-color': article.is_read ? '#f7f7f7' : 'white' }"
      @click="toDetail(article.id)"
    >
      <view class="u-head-item" slot="head">
        <img-cache
          class="feed_icon"
          mode="aspectFill"
          :src="article.feed_icon"
        />
        <view class="feed_title">{{ article.feed_title }}</view>
        <text class="article_time">{{ article.time }}</text>
      </view>
      <view class="u-body-item u-flex u-col-between u-p-t-0" slot="body">
        <view class="">
          <view class="u-body-item-title u-line-2">{{ article.title }}</view>
          <text
            class="article_describtion"
            v-if="article.description == '&hellip;' ? true : false"
          >
            {{ article.description }}
          </text>
          <img-cache
            :src="article.flavor_image"
            mode="aspectFill"
            v-if="article.flavor_image ? true : false"
          >
          </img-cache>
        </view>
      </view>
    </u-card>
  </view>
</template>

<script>
import htmlToText from "html-to-text";
import Popup from "./components/popup";

export default {
  name: 'List',
  components: {
    Popup,
  },
  data() {
    return {
      isReadBodyStyle: {
        "background-color": "#f7f7f7",
      },
      isReadHeadStyle: {
        "background-color": "#f7f7f7",
        "border-bottom-color": "rgb(228, 231, 237)",
        "border-bottom-style": "solid",
        "border-bottom-width": "1px",
      },
      articles: {
        list: [],
      },
      feeds: {
        list: [],
      },
      feed_tree: {
        list: [],
      },
      url: process.env.VUE_APP_URL,
    };
  },
  onLoad() {
    this.getFeeds();
    this.getArticles();
    this.getRead();
  },

  onShow() {
    this.getRead();
  },

  onNavigationBarButtonTap() {
    this.$refs.Popup.showDrawer();
  },

  onPullDownRefresh() {
    this.refreshArticles();
    this.refreshFeeds();
    this.refreshFeedTree();
    uni.stopPullDownRefresh();
  },

  methods: {
    getRead() {
      try {
        const is_read_list = uni.getStorageSync("is_read_list");
        for (var index in this.articles.list) {
          if (is_read_list.indexOf(this.articles.list[index].id) > -1) {
            this.$set(this.articles.list[index], "is_read", true);
          } else {
            this.$set(this.articles.list[index], "is_read", false);
          }
        }
      } catch (e) {
        pass;
      }
    },
    getFeeds() {
      const feeds = uni.getStorageSync("feeds");
      if (feeds) {
        this.feeds.list = feeds;
      } else {
        this.refreshFeeds();
      }

      const feed_tree = uni.getStorageSync("feed_tree");
      if (feed_tree) {
        this.feed_tree.list = feed_tree;
      } else {
        this.refreshFeedTree();
      }
    },
    refreshFeeds() {
      uni.request({
        url: this.url + "/get_feeds",
        method: "GET",
        success: (res) => {
          const { data } = res.data;
          uni.setStorageSync("feeds", data);
          this.feeds.list = data;
        },
      });
    },
    refreshFeedTree() {
      uni.request({
        url: this.url + "/get_feed_tree",
        method: "GET",
        success: (res) => {
          const { data } = res.data;
          uni.setStorageSync("feed_tree", data);
          this.feed_tree.list = data;
        },
      });
    },
    getArticles() {
      const articles = uni.getStorageSync("articles");
      if (articles) {
        this.articles.list = articles;
      } else {
        this.refreshArticles();
      }
    },
    refreshArticles() {
      uni.request({
        url: this.url + "get_unreads",
        method: "GET",
        success: (res) => {
          const { data } = res.data;
          const feeds = uni.getStorageSync("feeds");
          for (var index in data) {
            const description = htmlToText.fromString(data[index].description, {
              wordwrap: 130,
            });
            data[index].description = description;
            const id = data[index].feed_id;
            data[index]["feed_icon"] = feeds[id].feed_icon;
          }
          uni.setStorageSync("articles", data);
          this.articleSync();
        },
      });
    },
    articleSync() {
      const data = uni.getStorageSync("articles");
      this.$set(this.articles, "list", data);
    },
    toDetail(id) {
      try {
        const is_read_list = uni.getStorageSync("is_read_list");
        if (is_read_list.indexOf(id) == -1) {
          is_read_list.push(id);
        }
        uni.setStorageSync("is_read_list", is_read_list);
      } catch (e) {
        uni.setStorageSync("is_read_list", [id]);
      }
      uni.navigateTo({
        url: `/pages/index/detail?id=${id}`,
      });
    },
  },
};
</script>

<style>
.content {
  display: flex;
  flex-direction: column;
  justify-content: center;
  background-color: white;
}

.feed_title {
  font-size: 28rpx;
  padding-left: 20rpx;
  display: inline-block;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  width: 365rpx;
}

.feed_icon {
  width: 30rpx;
  height: 30rpx;
}

.article_time {
  font-size: 28rpx;
  margin-left: auto;
  color: #8f8f94;
}

.u-head-item {
  display: flex;
  flex-direction: row;
  align-items: center;
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
  /* max-height: 240rpx; */
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
