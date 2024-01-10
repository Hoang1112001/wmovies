<!-- eslint-disable vue/no-use-v-if-with-v-for -->
<!-- eslint-disable vue/valid-v-for -->
<!-- eslint-disable vue/require-v-for-key -->
<template>
  <v-app>
    <v-btn
      @click="showHideChatBox"
      fab
      dark
      fixed
      absolute
      small
      class="chatButton"
      color="error"
    >
      <v-icon>{{
        isShowChatBox ? 'mdi-close-thick' : 'mdi-chat-processing'
      }}</v-icon></v-btn
    >
    <!-- <div v-if="isShowChatBox" class="chatbox-container">
      <div class="container">
        <div>
          <h3 class="red--text text-center">WMovies Support</h3>
          <v-chip-group
            v-model="selectedOptionChat"
            @change="handleOptionChat"
            column
            active-class="error--text"
          >
            <v-chip
              filter
              outlined
              v-for="size in optionChat"
              :key="size"
              :value="size"
            >
              {{ size }}
            </v-chip>
          </v-chip-group>
        </div>
        <div class="messageBox mt-2">
          <template v-for="message in messages">
            <div
              :class="
                message.from == 'user'
                  ? 'userMessageContent'
                  : 'chatGptMessageContent'
              "
            >
              <div>{{ message.data }}</div>
              <template
                v-if="message.actions"
                v-for="action in message.actions"
              >
                <v-btn chip small>{{ action.text }}</v-btn>
              </template>
            </div>
          </template>
        </div>
        <div class="inputContainer">
          <input
            :disabled="
              selectedOptionChat === null || selectedOptionChat === undefined
            "
            @keypress.enter="sendMessage(currentMessage)"
            v-model="currentMessage"
            type="text"
            class="messageInput"
            placeholder="Vui lòng chọn nội dung ..."
          />
          <v-btn
            color="error"
            :disabled="
              selectedOptionChat === null || selectedOptionChat === undefined
            "
            @click="sendMessage(currentMessage)"
            class="askButton"
          >
            <v-icon>mdi-arrow-right</v-icon>
          </v-btn>
        </div>
      </div>
    </div> -->
    <div v-show="isShowChatBox" class="chatbox-container">
      <v-responsive
        class="overflow-y-hidden fill-height"
        width="500"
        height="500"
        eager
      >
        <v-card
          v-model="isShowChatBox"
          class="d-flex flex-column fill-height red lighten-5"
          elevation="15"
          eager
          rounded
        >
          <v-card-title class="d-flex flex-column">
            <h3 class="red--text text-center">WMovies Support</h3>
            <v-chip-group
              v-model="selectedOptionChat"
              @change="handleOptionChat"
              column
              active-class="error--text"
            >
              <v-chip
                :disabled="isLoadingOption"
                filter
                outlined
                v-for="size in optionChat"
                :key="size"
                :value="size"
              >
                {{ size }}
              </v-chip>
            </v-chip-group>
          </v-card-title>

          <v-card-text class="flex-grow-1 overflow-y-auto" id="demo">
            <div
              v-for="(msg, index) in messages"
              :id="'box-' + index"
              :class="{ 'd-flex flex-row-reverse': msg.from === 'user' }"
            >
              <v-chip
                :color="msg.from === 'user' ? 'primary' : 'white'"
                style="height: auto; white-space: normal; overflow: hidden"
                class="pa-4 mb-2 font-weight-bold"
              >
                <pre style="white-space: pre-wrap">{{ msg.data }}</pre>
              </v-chip>
              <!-- <div v-if="msg.isLookUp" class="d-flex mb-2">
                <v-btn small rounded>Lưu</v-btn>
                <v-btn small rounded>Từ đồng nghĩa</v-btn>
                <v-btn small rounded>Từ trái nghĩa</v-btn>
                <v-btn small rounded>Ví dụ</v-btn>
              </div> -->
            </div>
          </v-card-text>

          <v-card-text class="flex-shrink-1">
            <v-text-field
              v-model="currentMessage"
              label="Nhập thông tin ở đây"
              :disabled="
                selectedOptionChat === null ||
                selectedOptionChat === undefined ||
                isLoadingOption === true
              "
              type="text"
              no-details
              outlined
              append-outer-icon="mdi-send"
              @keyup.enter="sendMessage(currentMessage)"
              @click:append-outer="sendMessage(currentMessage)"
              hide-details
            />
          </v-card-text>
        </v-card>
      </v-responsive>
    </div>
  </v-app>
</template>

<script>
import axios from 'axios'
import gql from 'graphql-tag'

export default {
  name: 'ChatBox',
  data() {
    return {
      isLoadingOption: false,
      isShowChatBox: false,
      selectedOptionChat: null,
      optionChat: ['Tra từ', 'Tra nghĩa câu', 'Tìm kiếm phim'],
      currentMessage: '',
      messages: [],
    }
  },
  mounted() {
    this.messages = []
    if (localStorage.getItem('historyChat')) {
      const arrayHistory = JSON.parse(localStorage.getItem('historyChat'))
      for (let index = 0; index < arrayHistory.length; index++) {
        const element = arrayHistory[index]
        this.messages.push(element)
      }
    }
  },
  watch: {
    isShowChatBox() {
      if (this.isShowChatBox) {
        if (this.messages && this.messages.length > 0) {
          this.$nextTick(() => {
            const container = document.querySelector('#demo')
            if (
              container &&
              container.childNodes &&
              container.childNodes.length > 0
            ) {
              //  eslint-disable-next-line no-unused-vars
              const targetElement = container.querySelector(
                `#box-${container.childNodes.length - 1}`
              )

              const distance = targetElement.offsetTop - container.offsetTop
              container.scrollTop = distance
            }
            // ...
          })
        }
      }
    },
    messages() {
      if (this.messages && this.messages.length > 0) {
        this.$nextTick(() => {
          const container = document.querySelector('#demo')
          if (
            container &&
            container.childNodes &&
            container.childNodes.length > 0
          ) {
            //  eslint-disable-next-line no-unused-vars
            const targetElement = container.querySelector(
              `#box-${container.childNodes.length - 1}`
            )

            const distance = targetElement.offsetTop - container.offsetTop
            container.scrollTop = distance
          }
          // ...
        })
      }
    },
    // selectedOptionChat() {
    //   if (this.selectedOptionChat) {
    //     console.log(this.selectedOptionChat)
    //   }
    // },
  },
  methods: {
    showHideChatBox() {
      if (this.isShowChatBox) {
        this.isShowChatBox = false
      } else {
        this.isShowChatBox = true
        if (this.messages.length === 0) {
          setTimeout(() => {
            this.messages.push({
              from: 'bot',
              data: 'Xin chào ! Tôi có thể giúp gì cho bạn ?',
            })
          }, 1000)
        }
      }
    },
    handleOptionChat() {
      console.log(this.selectedOptionChat)
      if (
        this.selectedOptionChat === null ||
        this.selectedOptionChat === undefined
      ) {
        setTimeout(() => {
          this.messages.push({
            from: 'bot',
            data: 'Vui lòng chọn nội dung cần hỗ trợ !',
          })
        }, 1000)
      } else {
        this.isLoadingOption = true
        setTimeout(() => {
          this.messages.push({
            from: 'user',
            data: this.selectedOptionChat,
          })
        }, 1000)
        if (this.selectedOptionChat === 'Tra từ') {
          setTimeout(() => {
            this.isLoadingOption = false
            this.messages.push({
              from: 'bot',
              data: 'Vui lòng nhập từ cần tra (Ví dụ: Home, Go, ...)',
            })
          }, 3000)
        }
        if (this.selectedOptionChat === 'Tra nghĩa câu') {
          setTimeout(() => {
            this.isLoadingOption = false
            this.messages.push({
              from: 'bot',
              data: 'Vui lòng nhập câu từ cần tra nghĩa (Ví dụ: I want to be a developer)',
            })
          }, 3000)
        }
        if (this.selectedOptionChat === 'Tìm kiếm phim') {
          setTimeout(() => {
            this.isLoadingOption = false
            this.messages.push({
              from: 'bot',
              data: 'Vui lòng nhập tên phim cần tìm (Ví dụ: Breaking Bad)',
            })
          }, 3000)
        }
      }
    },
    async sendMessage(message) {
      if (
        this.selectedOptionChat === 'Tra từ' &&
        (message === '' || !message)
      ) {
        this.messages.push({
          from: 'bot',
          data: 'Vui lòng nhập từ ngữ cần tra', // Access the 'data' property of the response object
        })
        return
      }
      if (
        this.selectedOptionChat === 'Tra từ' &&
        message &&
        message !== '' &&
        message.length > 0
      ) {
        const check = message.split(' ')
        if (check.length > 1) {
          this.messages.push({
            from: 'bot',
            data: 'Vui lòng nhập từ ngữ cần tra (một từ)', // Access the 'data' property of the response object
          })
          return
        }
      }
      this.currentMessage = ''

      this.messages.push({
        from: 'user',
        data: message,
      })
      if (this.selectedOptionChat === 'Tra từ') {
        this.isLoadingOption = true
        let dataWord = null
        const stringSearch = message.replace(/[&/\\#,+().$~%:*"?<>{}]/g, '')
        const queryWord = gql(`query MyQuery {
                dictionaries(where: {word : {_eq: "${stringSearch}"}}){
                  id
                  word
                  pronunciation
                  type
                  meaning
                  example
                }
        }`)
        await this.$apollo
          .query({
            query: queryWord,
            fetchPolicy: 'network-only',
          })
          .then((response) => {
            if (
              response.data.dictionaries &&
              response.data.dictionaries.length > 0
            ) {
              dataWord = response.data.dictionaries[0]
            } else {
              //
            }
          })
          .catch((response) => console.log(response))
        if (dataWord) {
          this.messages.push({
            from: 'bot',
            data: `
- Từ: ${dataWord.word}
- Phiên âm: /${dataWord.pronunciation}/
- Loại từ: ${dataWord.type}
- Ý nghĩa: ${dataWord.meaning}
        `,
          })
          if ('speechSynthesis' in window) {
            // Tạo một instance của SpeechSynthesisUtterance
            const utterance = new SpeechSynthesisUtterance()

            // Thiết lập ngôn ngữ và nội dung cần đọc
            utterance.lang = 'en-US' // Ngôn ngữ tiếng Anh
            utterance.text = dataWord.word // Nội dung cần đọc
            console.log('GỌi NÈ')
            // Gọi phương thức speechSynthesis.speak() để đọc nội dung
            window.speechSynthesis.speak(utterance)
          } else {
            console.error('Trình duyệt không hỗ trợ API Web Speech.')
          }
        } else {
          try {
            await axios
              .post(`${process.env.URL_SERVER}/chatbot/look-up-word`, {
                message: `Cho biết các thông tin sau của từ "${stringSearch}",
            trả lời theo cấu trúc json: 
            { 
              word: Từ cần tra ,
              pronunciation: Phiên âm từ,
              description: Mô tả ý nghĩa (tiếng Việt),
              example: Ví dụ một câu có sử dụng từ (tiếng Anh),
              type: Loại từ (tiếng Anh)
            },
         ,`,
              })
              .then((response) => {
                this.isLookingUp = false
                if (response && response.data) {
                  if (response.data.status) {
                    dataWord = response.data.data[0]
                    this.messages.push({
                      from: 'bot',
                      data: `
- Từ: ${dataWord.word}
- Phiên âm: /${dataWord.pronunciation}/
- Loại từ: ${dataWord.type}
- Ý nghĩa: ${dataWord.meaning}
                      `,
                    })
                    if ('speechSynthesis' in window) {
                      // Tạo một instance của SpeechSynthesisUtterance
                      const utterance = new SpeechSynthesisUtterance()

                      // Thiết lập ngôn ngữ và nội dung cần đọc
                      utterance.lang = 'en-US' // Ngôn ngữ tiếng Anh
                      utterance.text = dataWord.word // Nội dung cần đọc
                      console.log('GỌi NÈ')
                      // Gọi phương thức speechSynthesis.speak() để đọc nội dung
                      window.speechSynthesis.speak(utterance)
                    } else {
                      console.error('Trình duyệt không hỗ trợ API Web Speech.')
                    }
                  } else {
                    this.snackbar = true
                    this.textSnackbar =
                      'Có lỗi xảy ra trong quá trình tra từ ! Vui lòng thử lại'
                  }
                } else {
                  this.snackbar = true
                  this.textSnackbar =
                    'Có lỗi xảy ra trong quá trình tra từ ! Vui lòng thử lại'
                }
              })
              .catch((error) => {
                this.isLookingUp = false
                console.log(error)
                this.snackbar = true
                this.textSnackbar =
                  'Có lỗi xảy ra trong quá trình tra từ ! Vui lòng thử lại'
              })
          } catch (error) {
            this.isLookingUp = false
            console.error(error)
            this.wordLookup = {
              stringSearch,
              pronunciation: '',
              definition: 'Unknown',
              partOfSpeech: '',
            }
            this.cardLookUp = true
            if ('speechSynthesis' in window) {
              // Tạo một instance của SpeechSynthesisUtterance
              const utterance = new SpeechSynthesisUtterance()

              // Thiết lập ngôn ngữ và nội dung cần đọc
              utterance.lang = 'en-US' // Ngôn ngữ tiếng Anh
              utterance.text = stringSearch // Nội dung cần đọc
              // Gọi phương thức speechSynthesis.speak() để đọc nội dung
              window.speechSynthesis.speak(utterance)
            } else {
              console.error('Trình duyệt không hỗ trợ API Web Speech.')
            }
          }
        }
      }
      if (this.selectedOptionChat === 'Tra nghĩa câu') {
        this.isLoadingOption = true

        const stringSearch = message.replace(/[&/\\#,+().$~%:*"?<>{}]/g, '')

        try {
          await axios
            .post(`${process.env.URL_SERVER}/chatbot/look-up-couplet`, {
              message: `Cho biết ý nghĩa của câu sau: "${stringSearch}",
                          trả lời ngắn gọn, sát nghĩa
         ,`,
            })
            .then((response) => {
              this.isLookingUp = false
              if (response && response.data) {
                if (response.data) {
                  this.messages.push({
                    from: 'bot',
                    data: `${response.data.data}`,
                  })
                } else {
                  this.snackbar = true
                  this.textSnackbar =
                    'Có lỗi xảy ra trong quá trình tra nghĩa câu ! Vui lòng thử lại'
                }
              } else {
                this.snackbar = true
                this.textSnackbar =
                  'Có lỗi xảy ra trong quá trình tra nghĩa câu ! Vui lòng thử lại'
              }
            })
            .catch((error) => {
              this.isLookingUp = false
              console.log(error)
              this.snackbar = true
              this.textSnackbar =
                'Có lỗi xảy ra trong quá trình tra từ ! Vui lòng thử lại'
            })
        } catch (error) {
          this.isLookingUp = false
          console.error(error)
          this.wordLookup = {
            stringSearch,
            pronunciation: '',
            definition: 'Unknown',
            partOfSpeech: '',
          }
          this.cardLookUp = true
          if ('speechSynthesis' in window) {
            // Tạo một instance của SpeechSynthesisUtterance
            const utterance = new SpeechSynthesisUtterance()

            // Thiết lập ngôn ngữ và nội dung cần đọc
            utterance.lang = 'en-US' // Ngôn ngữ tiếng Anh
            utterance.text = stringSearch // Nội dung cần đọc
            // Gọi phương thức speechSynthesis.speak() để đọc nội dung
            window.speechSynthesis.speak(utterance)
          } else {
            console.error('Trình duyệt không hỗ trợ API Web Speech.')
          }
        }
      }
      localStorage.removeItem('historyChat')
      localStorage.setItem('historyChat', JSON.stringify(this.messages))
      this.isLoadingOption = false
    },
  },
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap');

.chatbox-container {
  /* position: fixed; */
  bottom: 24px;
  right: 24px;
  z-index: 500;
}

.container {
  width: 360px;
  height: 500px;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  font-family: 'Roboto', sans-serif;
}

h1 {
  font-size: 24px;
  font-weight: 500;
  text-align: center;
  color: #222;
  padding: 16px;
  margin: 0;
  background-color: #f7f7f7;
  border-bottom: 1px solid #e7e7e7;
}

.messageBox {
  padding: 16px;
  flex-grow: 1;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.messageFromUser,
.messageFromChatGpt {
  display: flex;
}

.messageBox {
  max-height: 400px;
  overflow-y: auto;
  padding: 0 16px;
  border-top: 1px solid #f0f0f0;
  border-bottom: 1px solid #f0f0f0;
  flex-grow: 1;
}

.messageFromUser,
.messageFromChatGpt {
  display: flex;
  margin-bottom: 8px;
}

.userMessageWrapper,
.chatGptMessageWrapper {
  display: flex;
  flex-direction: column;
}

.userMessageWrapper {
  align-self: flex-end;
}

.chatGptMessageWrapper {
  align-self: flex-start;
}

.userMessageContent {
  display: flex;
  justify-content: flex-end;
  align-items: flex-end;
  max-width: 100%;
  padding: 8px 12px;
  border-radius: 18px;
  margin-bottom: 2px;
  font-size: 14px;
  line-height: 1.4;
  margin-left: 30px;
  word-wrap: break-word;
}
.chatGptMessageContent {
  max-width: 100%;
  padding: 8px 12px;
  border-radius: 18px;
  margin-bottom: 2px;
  font-size: 14px;
  line-height: 1.4;
  margin-right: 30px;
}

.userMessageContent {
  background-color: #1877f2;
  color: white;
  /* border-top-left-radius: 0; */
}

.chatGptMessageContent {
  background-color: #ededed;
  color: #222;
  /* border-top-right-radius: 0; */
}

.userMessageTimestamp,
.chatGptMessageTimestamp {
  font-size: 10px;
  color: #999;
  margin-top: 2px;
}

.userMessageTimestamp {
  align-self: flex-end;
}

.chatGptMessageTimestamp {
  align-self: flex-start;
}

.inputContainer {
  display: flex;
  align-items: center;
  padding: 8px;
  background-color: #f0f0f0;
}

.messageInput {
  flex-grow: 1;
  border: none;
  outline: none;
  padding: 12px;
  font-size: 16px;
  background-color: white;
  border-radius: 24px;
  margin-right: 8px;
}

.askButton {
  background-color: #1877f2;
  color: white;
  font-size: 16px;
  padding: 8px 16px;
  border: none;
  outline: none;
  cursor: pointer;
  border-radius: 24px;
  transition: background-color 0.3s ease-in-out;
}
.chatButton {
  bottom: 60px;
  right: 17px;
}

@media (max-width: 480px) {
  .container {
    width: 100%;
    max-width: none;
    border-radius: 0;
  }
}
.chatbox-container {
  position: fixed;
  bottom: 104px;
  right: 24px;
  z-index: 2;
}

.messageBox {
  padding: 16px;
  flex-grow: 1;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.messageFromUser,
.messageFromChatGpt {
  display: flex;
}
</style>
