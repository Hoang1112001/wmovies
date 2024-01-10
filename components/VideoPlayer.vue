<!-- eslint-disable no-lonely-if -->
<template>
  <v-container fluid>
    <v-row>
      <v-col cols="12">
        <div
          class="video-container"
          @mouseover="isHoverVideo = true"
          @mouseleave="isHoverVideo = false"
        >
          <video
            id="video"
            ref="videoPlayer"
            :muted="isMuted"
            autoplay
            disablepictureinpicture
            playsinline
            crossorigin
            controlslist="nodownload noremoteplayback"
          >
            <source
              type="video/mp4"
              src="https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv"
            />
            <track
              default
              label="English"
              kind="captions"
              srclang="en"
              src="https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt"
            />
            <track
              label="VietNam"
              kind="captions"
              srclang="vi"
              src="https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VN%20(1).vtt"
            />
          </video>
          <div class="subtitles-container">
            <div class="subtitle-row" ref="subtitleTrackWrapperEN">
              <span class="subtitle-eng"></span>
            </div>
            <div class="subtitle-row" ref="subtitleTrackWrapperVN">
              <span class="subtitle-vn">Vietnamese Subtitle</span>
            </div>
            <div class="control-row d-flex justify-center" v-if="isHoverVideo">
              <v-col
                class="d-flex justify-start align-center"
                cols="12"
                sm="2"
                lg="3"
                xl="2"
                md="3"
              >
                <v-btn @click="togglePlayPause" fab small color="error">
                  <v-icon> {{ isPlaying ? 'mdi-pause' : 'mdi-play' }}</v-icon>
                </v-btn>
                <v-btn
                  fab
                  small
                  color="error"
                  @click="toggleMute"
                  class="volume-btn ml-2"
                >
                  <v-icon>{{
                    isMuted ? 'mdi-volume-off' : 'mdi-volume-high'
                  }}</v-icon>
                </v-btn>
                <v-slider
                  v-model="volume"
                  thumb-color="white"
                  track-color="grey"
                  track-fill-color="error"
                  min="0"
                  max="100"
                  class="custom-volume mt-6"
                  @input="setVolume"
                ></v-slider
              ></v-col>
              <v-col
                class="d-flex align-center"
                cols="12"
                sm="8"
                lg="7"
                xl="8"
                md="7"
              >
                <span class="time-display">{{ formatTime(currentTime) }}</span>
                <v-slider
                  thumb-color="white"
                  track-color="grey"
                  track-fill-color="error"
                  v-model="currentTime"
                  :max="duration"
                  step="1"
                  class="custom-slider mt-6"
                  @input="seekToTime"
                ></v-slider>

                <span class="time-display">{{
                  formatTime(duration)
                }}</span></v-col
              >
              <v-col
                class="d-flex justify-end align-center"
                cols="12"
                sm="2"
                lg="2"
                xl="2"
                md="2"
              >
                <v-menu top offset-y>
                  <template v-slot:activator="{ on, attrs }">
                    <v-btn
                      small
                      fab
                      color="error"
                      dark
                      v-bind="attrs"
                      v-on="on"
                    >
                      <v-icon>mdi-closed-caption</v-icon>
                    </v-btn>
                  </template>
                  <v-list dense>
                    <v-list-item
                      dense
                      v-for="color in menuSubtitles"
                      :key="color.code"
                    >
                      <v-list-item-action>
                        <v-checkbox
                          v-model="selectedSubtitle"
                          :value="color.code"
                        />
                      </v-list-item-action>
                      <v-list-item-content>
                        <v-list-item-title>{{ color.label }}</v-list-item-title>
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                </v-menu>
                <v-btn
                  class="ml-2"
                  small
                  fab
                  color="error"
                  dark
                  @click="toggleFullscreen"
                >
                  <v-icon>mdi-fullscreen</v-icon>
                </v-btn>
              </v-col>
            </div>
          </div>
        </div>
      </v-col>
      <v-col cols="12">
        <v-row>
          <v-btn>
            <v-checkbox></v-checkbox>
            Luyện nghe
          </v-btn>
          <v-btn>
            <v-checkbox></v-checkbox>
            Tra từ
          </v-btn>
          <v-btn>
            <v-checkbox></v-checkbox>
            Tùy chỉnh
          </v-btn>
          <v-btn>
            <v-checkbox></v-checkbox>
            Tra từ
          </v-btn>
        </v-row>
      </v-col>
    </v-row>
  </v-container>
</template>
<script>
export default {
  name: 'VideoPlayer',
  props: {
    options: {
      type: Object,
      default() {
        return {}
      },
    },
  },
  data() {
    return {
      volume: 50,
      currentTime: 0,
      duration: 0,
      isMuted: true,
      isPlaying: true,
      menuSubtitles: [
        {
          code: 'off',
          label: 'Off Sub',
        },
        {
          code: 'en',
          label: 'English',
        },
        {
          code: 'vi',
          label: 'Vietnam',
        },
        {
          code: 'en-vi',
          label: 'English-Vietnam',
        },
        {
          code: 'vi-en',
          label: 'Vietnam-English',
        },
      ],
      selectedSubtitle: null,
      offset: true,
      textTrack: '',
      isHoverVideo: false,
      showTextTrack: true,
      player: null,
      sources: [
        {
          src: 'https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv',
          type: 'video/mp4',
        },
      ],
    }
  },
  mounted() {
    const video = this.$refs.videoPlayer

    const videoWorks = !!document.createElement('video').canPlayType
    if (videoWorks) {
      console.log('Có hỗ trợ HTML5')
      video.controls = false
    }

    this.$refs.videoPlayer.addEventListener('loadedmetadata', this.setDuration)
    this.$refs.videoPlayer.addEventListener('timeupdate', this.setCurrentTime)
    this.selectedSubtitle = 'en'
    const textTrack = this.$refs.videoPlayer.textTracks[0]
    textTrack.mode = 'hidden'
    textTrack.addEventListener('cuechange', () => {
      const cues = textTrack.activeCues
      if (cues.length > 0) {
        const styleSpan =
          this.$refs.subtitleTrackWrapperEN.querySelector('span')
        styleSpan.innerHTML = cues[0].text
        styleSpan.style.border = '1px solid black'
        styleSpan.style['border-radius'] = '5px'
        styleSpan.style.padding = '1px'
        styleSpan.style.color = 'yellow'
        // styleSpan.style.display = 'flex'
        styleSpan.style['background-color'] = 'black'
        styleSpan.style['font-size'] = '20px'
        styleSpan.style['font-weight'] = 'bold'
        styleSpan.style['text-align'] = 'center'
        //

        const styleSpan2 =
          this.$refs.subtitleTrackWrapperVN.querySelector('span')
        styleSpan2.innerHTML = cues[0].text
        styleSpan2.style.border = '1px solid black'
        styleSpan2.style['border-radius'] = '5px'
        styleSpan2.style.padding = '1px'
        styleSpan2.style.color = 'white'
        // styleSpan.style.display = 'flex'
        styleSpan2.style['background-color'] = 'black'
        styleSpan2.style['font-size'] = '20px'
        styleSpan2.style['font-weight'] = 'bold'
        styleSpan2.style['text-align'] = 'center'
      }
    })
  },
  // eslint-disable-next-line vue/order-in-components
  watch: {
    // isHoverVideo() {
    //   const videoControls = this.$refs.videoControls
    //   const subtitleContainerEN = this.$refs.subtitleTrackWrapperEN
    //   const subtitleContainerVN = this.$refs.subtitleTrackWrapperVN
    //   if (this.isHoverVideo) {
    //     // Thanh công cụ
    //     videoControls.style.position = 'absolute'
    //     videoControls.style.visibility = 'visible'
    //     videoControls.style.opacity = 1
    //     videoControls.style.display = 'inline'
    //     videoControls.style.bottom = 0
    //     videoControls.style.left = 0
    //     videoControls.style.height = '70px'
    //     videoControls.style.transition = 'opacity 0.5s linear'
    //     // Title Eng
    //     if (this.selectedSubtitle === 'en') {
    //       subtitleContainerEN.style.bottom = '10%'
    //       subtitleContainerEN.style.left = 0
    //     } else if (this.selectedSubtitle === 'vi') {
    //       subtitleContainerVN.style.bottom = '10%'
    //       subtitleContainerVN.style.left = 0
    //     } else if (this.selectedSubtitle === 'en-vi') {
    //       subtitleContainerEN.style.bottom = '20%'
    //       subtitleContainerEN.style.left = 0
    //       subtitleContainerVN.style.bottom = '10%'
    //       subtitleContainerVN.style.left = 0
    //     } else if (this.selectedSubtitle === 'vi-en') {
    //       subtitleContainerEN.style.bottom = '10%'
    //       subtitleContainerEN.style.left = 0
    //       subtitleContainerVN.style.bottom = '20%'
    //       subtitleContainerVN.style.left = 0
    //     } else {
    //       subtitleContainerEN.style.display = 'none'
    //       subtitleContainerVN.style.display = 'none'
    //     }
    //     // // Title VN
    //     // subtitleContainerVN.style.position = 'absolute'
    //     // subtitleContainerVN.style.bottom = '1%'
    //     // subtitleContainerVN.style.left = 0
    //     // subtitleContainerVN.style.width = '100%'
    //     // subtitleContainerVN.style['text-align'] = 'center'
    //     // subtitleContainerVN.style.color = '#fff'
    //   } else {
    //     // Thanh công cụ
    //     videoControls.style.bottom = 0
    //     videoControls.style.left = 0
    //     videoControls.style.visibility = 'hidden'
    //     videoControls.style.opacity = 0
    //     videoControls.style.display = 'none'
    //     // Title Eng
    //     // Title Eng
    //     if (this.selectedSubtitle === 'en') {
    //       subtitleContainerEN.style.bottom = 0
    //       subtitleContainerEN.style.left = 0
    //       subtitleContainerEN.style.display = 'none'
    //     } else if (this.selectedSubtitle === 'vi') {
    //       subtitleContainerVN.style.bottom = 0
    //       subtitleContainerVN.style.left = 0
    //       subtitleContainerVN.style.display = 'none'
    //     } else if (this.selectedSubtitle === 'en-vi') {
    //       subtitleContainerEN.style.bottom = '10%'
    //       subtitleContainerEN.style.left = 0
    //       subtitleContainerVN.style.bottom = 0
    //       subtitleContainerVN.style.left = 0
    //     } else if (this.selectedSubtitle === 'vi-en') {
    //       subtitleContainerEN.style.bottom = '0%'
    //       subtitleContainerEN.style.left = 0
    //       subtitleContainerVN.style.bottom = '10%'
    //       subtitleContainerVN.style.left = 0
    //     } else {
    //       subtitleContainerEN.style.display = 'none'
    //       subtitleContainerVN.style.display = 'none'
    //     }
    //   }
    // },
    // selectedSubtitle() {
    //   const subtitleContainerEN = this.$refs.subtitleTrackWrapperEN
    //   const subtitleContainerVN = this.$refs.subtitleTrackWrapperVN
    //   if (this.isHoverVideo) {
    //     if (this.selectedSubtitle === 'en') {
    //       subtitleContainerEN.style.display = 'inline'
    //       subtitleContainerEN.style.bottom = '10%'
    //       subtitleContainerEN.style.left = 0
    //     } else if (this.selectedSubtitle === 'vi') {
    //       subtitleContainerVN.style.bottom = '10%'
    //       subtitleContainerVN.style.left = 0
    //     } else if (this.selectedSubtitle === 'en-vi') {
    //       subtitleContainerEN.style.bottom = '20%'
    //       subtitleContainerEN.style.left = 0
    //       subtitleContainerVN.style.bottom = '10%'
    //       subtitleContainerVN.style.left = 0
    //     } else if (this.selectedSubtitle === 'vi-en') {
    //       subtitleContainerEN.style.bottom = '10%'
    //       subtitleContainerEN.style.left = 0
    //       subtitleContainerVN.style.bottom = '20%'
    //       subtitleContainerVN.style.left = 0
    //     } else {
    //       subtitleContainerEN.style.display = 'none'
    //       subtitleContainerVN.style.display = 'none'
    //     }
    //     // // Title VN
    //     // subtitleContainerVN.style.position = 'absolute'
    //     // subtitleContainerVN.style.bottom = '1%'
    //     // subtitleContainerVN.style.left = 0
    //     // subtitleContainerVN.style.width = '100%'
    //     // subtitleContainerVN.style['text-align'] = 'center'
    //     // subtitleContainerVN.style.color = '#fff'
    //   } else {
    //     // Title Eng
    //     // Title Eng
    //     // eslint-disable-next-line no-lonely-if
    //     if (this.selectedSubtitle === 'en') {
    //       subtitleContainerEN.style.bottom = 0
    //       subtitleContainerEN.style.left = 0
    //       subtitleContainerEN.style.display = 'none'
    //     } else if (this.selectedSubtitle === 'vi') {
    //       subtitleContainerVN.style.bottom = 0
    //       subtitleContainerVN.style.left = 0
    //       subtitleContainerVN.style.display = 'none'
    //     } else if (this.selectedSubtitle === 'en-vi') {
    //       subtitleContainerEN.style.bottom = '10%'
    //       subtitleContainerEN.style.left = 0
    //       subtitleContainerVN.style.bottom = 0
    //       subtitleContainerVN.style.left = 0
    //     } else if (this.selectedSubtitle === 'vi-en') {
    //       subtitleContainerEN.style.bottom = '0%'
    //       subtitleContainerEN.style.left = 0
    //       subtitleContainerVN.style.bottom = '10%'
    //       subtitleContainerVN.style.left = 0
    //     } else {
    //       subtitleContainerEN.style.display = 'none'
    //       subtitleContainerVN.style.display = 'none'
    //     }
    //   }
    // },
  },
  methods: {
    setDuration() {
      this.duration = Math.floor(this.$refs.videoPlayer.duration)
    },
    seekToTime() {
      this.$refs.videoPlayer.currentTime = this.currentTime
    },
    setCurrentTime() {
      this.currentTime = Math.floor(this.$refs.videoPlayer.currentTime)
    },
    formatTime(time) {
      const minutes = Math.floor(time / 60)
      const seconds = Math.floor(time % 60)
      return `${this.padTime(minutes)}:${this.padTime(seconds)}`
    },
    padTime(time) {
      return time.toString().padStart(2, '0')
    },
    setVolume() {
      this.$refs.videoPlayer.volume = this.volume / 100
      if (this.$refs.videoPlayer.volume === 0) {
        this.isMuted = true
      } else {
        this.isMuted = false
      }
    },
    toggleMute() {
      if (this.isMuted) {
        this.$refs.videoPlayer.volume = this.volume / 100
        this.isMuted = false
      } else {
        this.$refs.videoPlayer.volume = 0
        this.isMuted = true
      }
    },
    togglePlayPause() {
      if (this.$refs.videoPlayer.paused) {
        this.isPlaying = true
        this.$refs.videoPlayer.play()
      } else {
        this.isPlaying = false
        this.$refs.videoPlayer.pause()
      }
    },
    toggleFullscreen() {
      const containerVideo = document.querySelector('.video-container')
      if (document.fullscreenElement) {
        // Nếu đã ở chế độ fullscreen, thoát fullscreen
        if (document.exitFullscreen) {
          document.exitFullscreen()
        }
      } else {
        // Nếu chưa ở chế độ fullscreen, vào fullscreen
        // eslint-disable-next-line no-lonely-if
        if (containerVideo.requestFullscreen) {
          containerVideo.requestFullscreen()
        }
      }
    },
  },
}
</script>
<style>
.v-ripple__container {
  opacity: 0 !important;
}

/* Thanh thời lượng */
.time-display {
  font-weight: bold;
  color: white;
}
.custom-slider .v-slider__track-container {
  height: 15px !important;
}
.custom-slider .v-slider__track {
  height: 15px !important;
}
.custom-slider .v-slider__thumb:before {
  opacity: 0 !important;
}

.custom-slider .v-slider__thumb {
  cursor: pointer;
  width: 24px; /* Chỉnh kích thước chiều ngang */
  height: 24px; /* Chỉnh kích thước chiều dọc */
}
/* Thanh volume */
.custom-volume .v-slider__track-container {
  height: 15px !important;
  width: 100px;
}
.custom-volume .v-slider__track {
  height: 15px !important;
}
.custom-volume .v-slider .v-slider__thumb {
  display: none;
}

.video-container {
  position: relative;
  width: 100%;
}

video {
  width: 100%;
  height: auto;
}

.subtitles-container {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  color: white;
}
.subtitle-row {
  justify-content: center;
  text-align: center;
  padding: 5px;
}
.subtitle-eng {
  text-align: center;
}

.subtitle-vn {
  margin-bottom: 15px;
}
.control-row {
  background-color: rgba(0, 0, 0, 0.2);
  max-height: 50px;
  justify-content: center;
  margin-bottom: 5px;
}
</style>
