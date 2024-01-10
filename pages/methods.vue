<template>
  <v-app>
    <v-card elevation="24" width="95%" style="margin: 10px auto" class="white">
      <v-card-title
        data-aos="zoom-in"
        data-aos-duration="1500"
        data-aos-delay="1500"
      >
        <span style="margin: 0 auto; color: orange; font-weight: bold"
          >CÁCH HỌC TIẾNG ANH QUA PHIM HIỆU QUẢ CHO NGƯỜI MỚI BẮT ĐẦU</span
        >
      </v-card-title>
      <!-- <v-card-text
        data-aos="zoom-in"
        data-aos-duration="1500"
        data-aos-delay="500"
        class="mx-auto"
      ></v-card-text> -->
      <!-- <v-img
        data-aos="zoom-in"
        data-aos-duration="1500"
        data-aos-delay="500"
        class="mt-n2"
        :src="require('~/static/methods.jpg')"
      ></v-img>
      <v-card-actions
        class="d-flex"
        data-aos="zoom-in"
        data-aos-duration="1500"
        data-aos-delay="1500"
      >
        <v-btn class="error mx-auto ma-2">
          Học thử ngay tại đây
        </v-btn></v-card-actions
      >

      <v-divider class="d-flex mx-auto"></v-divider> -->

      <v-row
        data-aos="fade-left"
        data-aos-duration="1500"
        data-aos-delay="1500"
        data-aos-once="true"
        class="d-flex mx-auto mt-2"
      >
        <v-col>
          <v-card-text class="d-flex">
            <v-avatar class="mt-n3" color="orange" size="50"
              ><v-icon>mdi-microphone</v-icon></v-avatar
            >
            <h2 class="font-weight-bold mt-1 ml-1 orange--text">
              LUYỆN NÓI THÔNG MINH
            </h2>
          </v-card-text>
          <v-card-text class="mt-n4">
            <p class="text-justify font-weight-bold mt-n1">
              Về mặt luyện nói, cách học tiếng anh qua phim trước đây có nhược
              điểm là các đoạn sub xuất hiện ngay khi nhân vật nói, điều đó
              khiến bạn chỉ có thể nói sau khi nhân vật trong phim đã nói mà
              không thể nói cùng lúc với nhân vật. Studyphim đã khắc phục nhược
              điểm trên như thế nào:
            </p>
            <p class="text-justify font-weight-bold mt-n1">
              - Luôn hiển thị sub nhân vật sắp nói: Để bạn chuẩn bị về mặt phát
              âm trước khi nhân vật kịp mở miệng.
            </p>
            <p class="text-justify font-weight-bold mt-n1">
              - Sub hiển thị 1 đoạn dài: Giúp bạn định hình, nhìn lại những câu
              đã nói và ghi nhớ.
            </p>
          </v-card-text>
          <v-card-text class="mt-n8">
            <h2 class="font-weight-bold mt-1 ml-1 orange--text">
              Luyện nói như thế nào ?
            </h2>
            <v-list>
              <v-list-item class="d-flex ml-n4 mt-n1">
                <v-icon class="mr-1" color="orange">mdi-check-decagram</v-icon>

                <v-list-item-content>
                  <span class="font-weight-bold text-justify"
                    >Nếu chỉ nói nhanh mà không phát âm tiếng anh chuẩn, bạn chỉ
                    như một bác xe ôm biết nói “tiếng bồi”. Để nói như người bản
                    xứ, hãy đọc theo phụ đề, bắt chước ngữ điệu, cách phát âm
                    của nhân vật.</span
                  >
                </v-list-item-content>
              </v-list-item>
              <v-list-item class="d-flex ml-n4 mt-n2">
                <v-icon class="mr-1" color="orange">mdi-check-decagram</v-icon>

                <v-list-item-content>
                  <span class="font-weight-bold text-justify"
                    >Luyện phản xạ tiếng anh: Sau giai đoạn 1, bạn dần giảm sự
                    tập trung vào phụ đề, chỉ nge và nói theo nhân vật. Đây là
                    phương pháp rất đơn giản, nhẹ nhàng , cơ bản và hiệu quả
                    giúp các câu hội thoại, ngữ cảnh giao tiếp thẩm thấu vào
                    tiềm thức.</span
                  >
                </v-list-item-content>
              </v-list-item>
            </v-list>
          </v-card-text>
        </v-col>
        <v-col>
          <v-img
            style="margin: 30px auto"
            max-width="500"
            max-height="500"
            :src="require('~/static/luyen-noi.jpg')"
          ></v-img
        ></v-col>
      </v-row>

      <v-divider class="d-flex mx-auto"></v-divider>

      <v-row
        data-aos="fade-right"
        data-aos-duration="1500"
        data-aos-delay="1500"
        data-aos-once="true"
        class="d-flex mx-auto mt-2"
      >
        <v-col>
          <v-img
            style="margin: 30px auto"
            max-width="500"
            max-height="500"
            :src="require('~/static/luyen-nghe.jpg')"
          ></v-img
        ></v-col>
        <v-col>
          <v-card-text class="d-flex">
            <v-avatar class="mt-n3" color="orange" size="50"
              ><v-icon>mdi-headphones</v-icon></v-avatar
            >
            <h2 class="font-weight-bold mt-1 ml-1 orange--text">
              LUYỆN NGHE HIỆU QUẢ
            </h2>
          </v-card-text>
          <v-card-text class="mt-n4">
            <p class="text-justify font-weight-bold">
              Điểm yếu lớn nhất cuả phương pháp học qua phim truyền thống và
              phương pháp xem phim 2 phụ đề thông thường là bạn sẽ rất khó học
              nghe được. Lý do là vì lúc đó, bạn không thể cưỡng lại sự hấp dẫn
              của phần phụ đề đang hiện lồ lộ lên màn ảnh. Thế là sau một phút
              cố gắng lắng tai nghe, mắt bạn tự động liếc xuống phần phụ đề. Bạn
              trở lại với phương pháp học tiếng Anh bằng cách đọc chứ không phải
              nghe chủ động.
            </p>
          </v-card-text>
          <v-card-text class="mt-n8">
            <h2 class="font-weight-bold mt-1 ml-1 orange--text">
              Luyện nghe như thế nào ?
            </h2>
            <v-list>
              <v-list-item class="d-flex ml-n4 mt-n1">
                <v-icon class="mr-1" color="orange">mdi-check-decagram</v-icon>

                <v-list-item-content>
                  <span class="font-weight-bold text-justify"
                    >Giảm tốc độ : Nếu bạn thấy phim quá khó nhằn, bạn có thể
                    giảm tốc độ xuống còn 80%, các câu thoại sẽ trở nên dễ hiểu
                    hơn rất nhiều. Điều tối quan trọng của việc học Anh ngữ là
                    bạn phải thấy dễ dàng và hứng thú. Nếu bạn thấy bài quá khó
                    so với trình độ của mình, hãy tìm bài dễ hơn hoặc giảm tốc
                    độ xuống. Đừng cố quá mà… quá cố!</span
                  >
                </v-list-item-content>
              </v-list-item>
              <v-list-item class="d-flex ml-n4 mt-n2">
                <v-icon class="mr-1" color="orange">mdi-check-decagram</v-icon>

                <v-list-item-content>
                  <span class="font-weight-bold text-justify"
                    >Tính năng luyện nghe: Để luyện nghe hiệu quả , bạn cần sự
                    tập trung, tránh sự xao nhãn, phụ thuộc quá mức vào phụ đề.
                    Với chức năng luyện nghe, toàn bộ phần phụ đề sẽ bị ẩn đi để
                    bạn tập trung hoàn toàn. Bất cứ khi nào không hiểu, bạn chỉ
                    cần bấm phím space là phần phụ đề song ngữ sẽ lại tự động
                    hiện ra.</span
                  >
                </v-list-item-content>
              </v-list-item>
              <v-list-item class="d-flex ml-n4">
                <v-icon class="mr-1" color="orange">mdi-check-decagram</v-icon>

                <v-list-item-content>
                  <span class="font-weight-bold text-justify"
                    >Tua lại 5 giây: Bấm phím Tab để tua lại đoạn hội thoại mà
                    bạn không nghe được.</span
                  >
                </v-list-item-content>
              </v-list-item>
            </v-list>
          </v-card-text>
        </v-col>
      </v-row>

      <v-divider class="d-flex mx-auto"></v-divider>
      <v-row
        data-aos="fade-left"
        data-aos-duration="1500"
        data-aos-delay="1500"
        data-aos-once="true"
        class="d-flex mx-auto mt-2"
      >
        <v-col>
          <v-card-text class="d-flex">
            <v-avatar class="mt-n3" color="orange" size="50"
              ><v-icon>mdi-book-open-variant</v-icon></v-avatar
            >
            <h2 class="font-weight-bold mt-1 ml-1 orange--text">
              CẢI THIỆN VỐN TỪ VỰNG
            </h2>
          </v-card-text>
          <v-card-text class="mt-n4">
            <p class="text-justify font-weight-bold mt-n1">
              Từ vựng là yếu tố không-thể-thiếu để có thể giao tiếp tiếng Anh
              lưu loát và “chuyên nghiệp”. Với cách học từ vựng tiếng anh qua
              phim truyền thống, bạn sẽ phát rồ lên vì cứ phải bật phụ đề, mở
              trình từ điển, tra từ điển, quay lại phim, tắt phụ đề để nghe
              tiếp… vừa mất thời gian, tốn công sức, vừa kém hiệu quả mà lại
              khiến bạn mau nản chí.
            </p>
            <p class="text-justify font-weight-bold mt-n1">
              - Hệ thống phụ đề song ngữ giúp bạn không cần phải mất công tra từ
              điển nữa, chỉ cần một cái liếc mắt là bạn đã có thể nhanh chóng
              nắm bắt ý nghĩa của từ mình vừa nghe được.
            </p>
            <p class="text-justify font-weight-bold mt-n1">
              - Việc học từ vựng qua phim có RẤT NHIỀU ưu điểm so với việc học
              chay thông thường: từ vựng được liên kết với một tình huống giao
              tiếp cụ thể. Bộ não con người ghi nhớ thông tin nhờ sự liên kết
              không ngưng nghỉ. Nhờ đó bạn dễ dàng ghi nhớ từ vựng, cách áp dụng
              và hoàn cảnh áp dụng hơn phương pháp học-gạo thông thường. Đó cũng
              là một trong những ưu điểm nổi trội của bí quyết học tiếng anh
              hiệu quả này
            </p>
          </v-card-text>
          <v-card-text class="mt-n8">
            <h2 class="font-weight-bold mt-1 ml-1 orange--text">
              Học từ vựng như thế nào?
            </h2>
            <v-list>
              <v-list-item class="d-flex ml-n4 mt-n1">
                <v-icon class="mr-1" color="orange">mdi-check-decagram</v-icon>

                <v-list-item-content>
                  <span class="font-weight-bold text-justify"
                    >Chuẩn bị một cuốn sổ tay để ghi chép những từ mới.</span
                  >
                </v-list-item-content>
              </v-list-item>
              <v-list-item class="d-flex ml-n4 mt-n2">
                <v-icon class="mr-1" color="orange">mdi-check-decagram</v-icon>

                <v-list-item-content>
                  <span class="font-weight-bold text-justify"
                    >Ghi chú lại ngữ cảnh dùng từ.</span
                  >
                </v-list-item-content>
              </v-list-item>
              <v-list-item class="d-flex ml-n4 mt-n2">
                <v-icon class="mr-1" color="orange">mdi-check-decagram</v-icon>

                <v-list-item-content>
                  <span class="font-weight-bold text-justify"
                    >Chỉ học những từ mà bạn cảm thấy đơn giản, gần gũi, “có vẻ”
                    phổ biến. Không học những từ ngữ quá chuyên ngành, hàn
                    lâm.</span
                  >
                </v-list-item-content>
              </v-list-item>
              <v-list-item class="d-flex ml-n4 mt-n2">
                <v-icon class="mr-1" color="orange">mdi-check-decagram</v-icon>

                <v-list-item-content>
                  <span class="font-weight-bold text-justify"
                    >Đừng lo lắng nếu bạn không thể áp dụng từ bạn đã học vào
                    quá trình giao tiếp ngay được.</span
                  >
                </v-list-item-content>
              </v-list-item>
            </v-list>
          </v-card-text>
        </v-col>
        <v-col>
          <v-img
            style="margin: 30px auto"
            max-width="500"
            max-height="500"
            :src="require('~/static/hoc-tu-vung.png')"
          ></v-img
        ></v-col>
      </v-row>
    </v-card>
  </v-app>
</template>
<script>
import AOS from 'aos'
import 'aos/dist/aos.css' // You can also use <link> for styles
AOS.init()
export default {
  data() {
    return {
      collapseOnScroll: true,
      clipped: false,
      drawer: false,
      fixed: false,
      fab: false,
      items: [
        {
          icon: 'mdi-apps',
          title: 'Welcome',
          to: '/',
        },
        {
          icon: 'mdi-chart-bubble',
          title: 'Inspire',
          to: '/inspire',
        },
      ],
      miniVariant: false,
      right: true,
      rightDrawer: false,
      title: 'Vuetify.js',
    }
  },

  methods: {},
}
</script>
<style></style>
