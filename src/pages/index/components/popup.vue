<template>
  <uni-drawer ref="drawer" class="popup">
    <view class="scroll-view">
      <scroll-view class="scroll-view-box" scroll-y="true">
        <uni-collapse
          accordion="true"
          :key="index"
          v-for="(category, index) of feed_tree"
        >
          <uni-collapse-item :title="category.category_name">
            <uni-list
              :key="index"
              v-for="(feed, index) of category.category_feed"
            >
              <uni-list-item
                :title="feed.feed_title"
                :thumb="feed.feed_icon"
              ></uni-list-item>
            </uni-list>
          </uni-collapse-item>
        </uni-collapse>
      </scroll-view>
    </view>
  </uni-drawer>
</template>

<script>
export default {
  name: "Popup",
  props: ["feeds", "feed_tree"],
  methods: {
    showDrawer() {
      this.$refs.drawer.open();
    },
  },
};
</script>

<style>
/* .popup {
  width: 200px;
} */

.category-feed_icon {
  width: 30rpx;
  height: 30rpx;
}

.category-name {
  font-size: 40rpx;
  font-weight: 500;
}

.category-feed_title_list {
  margin: 20rpx 5rpx 0;
  font-size: 28rpx;
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-bottom: 20rpx;
}

.category-feed_title {
  font-size: 28rpx;
  padding-left: 20rpx;
  display: inline-block;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  width: 400rpx;
}

.unread_num {
  font-size: 24rpx;
  margin-left: auto;
}

.scroll-view {
  /* #ifndef APP-NVUE */
  width: 100%;
  height: 100%;
  /* #endif */
  flex:1
}
.scroll-view-box {
		flex: 1;
		position: absolute;
		top: 0;
		right: 0;
		bottom: 0;
		left: 0;
	}
</style>
