<template>
  <v-container fluid color="error">
    <v-snackbar v-model="snackbar">
      {{ textSnackbar }}

      <template v-slot:action="{ attrs }">
        <v-btn color="pink" text v-bind="attrs" @click="snackbar = false">
          Close
        </v-btn>
      </template>
    </v-snackbar>
    <v-dialog v-model="dialogSave" width="unset">
      <v-card>
        <v-card-title class="h5 red--text">
          Bạn có muốn lưu không?</v-card-title
        >
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="dialogSave = false">Không</v-btn>
          <v-btn color="error" text @click="save()">Có</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-card style="height: 95vh">
      <v-card-title>
        <v-toolbar flat>
          <v-tooltip bottom>
            <template #activator="{ on, attrs }">
              <v-btn
                icon
                v-bind="attrs"
                v-on="on"
                color="error"
                @click="backToList()"
              >
                <v-icon>mdi-arrow-left</v-icon>
              </v-btn>
            </template>
            <span>Quay lại danh sách diễn viên phim</span>
          </v-tooltip>

          <v-toolbar-title v-if="isEdit" class="red--text font-weight-bold">{{
            `Chỉnh sửa diễn viên: ${title_name}`
          }}</v-toolbar-title>
          <v-toolbar-title v-if="!isEdit" class="red--text font-weight-bold">{{
            `Thêm diễn viên`
          }}</v-toolbar-title>
          <v-spacer></v-spacer>
          <v-btn tile color="error" :disabled="!valid" @click="openDialogSave">
            <v-icon color="white" left>mdi-content-save</v-icon>
            Lưu
          </v-btn>
        </v-toolbar></v-card-title
      >
      <v-card-text>
        <v-row class="mt-2 ml-2">
          <v-col
            cols="12"
            sm="6"
            lg="6"
            xl="6"
            md="6"
            style="margin-top: -20px"
            class="d-flex flex-column"
          >
            <v-text-field
              v-model="actor.code"
              label="Mã diễn viên"
              disabled
              class="required"
              color="red"
              outlined
              dense
            ></v-text-field>
            <v-text-field
              v-model="actor.name"
              label="Tên diễn viên"
              class="required"
              color="red"
              outlined
              dense
              @change="parseCodeActor"
            ></v-text-field>
            <v-textarea
              v-model="actor.introduce"
              outlined
              name="input-7-4"
              class="required"
              label="Giới thiệu diễn viên"
            ></v-textarea>
          </v-col>

          <v-col cols="12" sm="6" lg="6" xl="6" md="6">
            <v-file-input
              v-model="fileInput"
              @change="selectImage"
              dense
              style="margin-top: -20px"
              accept="image/png, image/jpeg, image/bmp"
              placeholder="Chọn ảnh diễn viên"
              prepend-icon="mdi-camera"
              label="Chọn ảnh diễn viên"
              class="required"
              outlined
            ></v-file-input>
            <v-text-field
              :value="editedImage.filename"
              label="Tên ảnh khi lưu"
              outlined
              dense
              readonly
            ></v-text-field>
            <v-img
              v-if="editedImage.url"
              :src="editedImage.url"
              height="150"
              width="150"
            >
            </v-img>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<script>
/* eslint-disable camelcase */
import axios from 'axios'
import gql from 'graphql-tag'
import moment from 'moment'

export default {
  layout: 'admin',
  components: {},
  asyncData({ route, params }) {
    let temp = null
    if (route.query.id != null && route.query.id !== undefined) {
      temp = route.query.id
    }
    let isEdit = false
    if (temp !== null && temp !== '0') {
      isEdit = true
    }
    if (temp !== null) {
      const objId = temp
      return { objId, isEdit }
    } else {
      const objId = 0
      return { objId, isEdit }
    }
  },
  data: () => ({
    valid: true,
    isEdit: true,
    dialogSave: false,
    snackbar: false,
    title_name: '',
    textSnackbar: '',
    fileInput: null,
    editedImage: {
      filename: '',
      info: null,
      url: null,
    },
    actor: {
      id: null,
      code: '',
      name: '',
      introduce: '',
      image_actor: null,
      created_at: null,
    },
  }),
  apollo: {
    actors: {
      query() {
        const query = gql(`query MyQuery {
          actors(where: {id: {_eq: ${this.objId}}}) {
              id
              code
              name
              introduce
              image_actor
              is_delete
              created_at
            }
          }`)
        return query
      },
      update: (data) => {},
      result({ data }) {
        if (data && data.actors && data.actors.length > 0) {
          this.actor = data.actors[0]
          if (data.actors[0].image_actor) {
            const images = this.$fire.storage.ref().child('actors')
            const image = images.child(data.actors[0].image_actor)
            image.getDownloadURL().then((url) => {
              this.editedImage.url = url
              this.editedImage.filename = data.actors[0].image_actor
            })
          }
        }
      },
    },
  },

  computed: {},

  watch: {},
  mounted() {},
  created() {},
  methods: {
    openDialogSave() {
      // Thêm mới

      if (!this.actor.introduce || this.actor.introduce === '') {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng nhập giới thiệu diễn viên'
        return
      }
      if (!this.actor.name || this.actor.name === '') {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng nhập tên diễn viên'
        return
      }

      this.dialogSave = true
    },
    async selectImage(e) {
      if (this.actor.name === '') {
        this.snackbar = true
        this.textSnackbar = 'Vui lòng nhập tên diễn viên trước khi chọn hình'
        this.fileInput = null
      } else {
        const file = e
        console.log(file)
        const readData = (f) =>
          new Promise((resolve) => {
            const reader = new FileReader()
            reader.onloadend = () => resolve(reader.result)
            reader.readAsDataURL(f)
          })
        const data = await readData(file)
        if (!file) return

        this.editedImage = {
          filename:
            this.actor.code +
            '-' +
            moment().format('DD-MM-YYYY') +
            '.' +
            file.type.split('/')[1],
          url: data,
          infoImage: file,
        }
      }
    },
    pushTo() {
      this.$toast.error(`Tài khoản không có quyền truy cập trang này`, {
        duration: 2000,
        position: 'top-center',
      })
      setTimeout(
        () =>
          this.$router.push({
            path: `/dashboard`,
          }),
        1500
      )
    },
    save() {
      this.dialogSave = false
      if (this.isEdit === true) {
        this.updateActor()
      } else {
        this.addActor()
      }
    },
    backToList() {
      this.$router.push({
        path: `/admin/actors/actors`,
      })
    },
    awaitDirect() {
      setTimeout(() => this.backToList(), 1500)
    },
    async addActor() {
      const queryCheck = gql(`query MyQuery {
                 actors(where: {name: {_ilike: "${this.actor.name}"}, is_delete: {_eq: false}}) {
                    id
                 }
              }`)
      await this.$apollo
        .query({
          query: queryCheck,
          fetchPolicy: 'network-only',
        })
        .then(async (response) => {
          if (response.data.actors.length > 0) {
            console.log(response.data.actors)
            this.snackbar = true
            this.textSnackbar = 'Diễn viên đã tồn tại'
          } else {
            const data_insert = {}
            data_insert.code = this.actor.code
            data_insert.name = this.actor.name
            data_insert.introduce = this.actor.introduce
            if (this.editedImage.filename) {
              data_insert.image_actor = this.editedImage.filename
            }
            // data_insert.created_by = this.actor.created_by
            await axios
              .post(`${process.env.URL_SERVER}/api/insert-actor`, {
                data_insert,
              })
              .then((response) => {
                if (response && response.data) {
                  if (response.data.status) {
                    this.textSnackbar = 'Thêm diễn viên thành công'
                    const storageRef = this.$fire.storage.ref(
                      'actors/' + this.editedImage.filename
                    )
                    const uploadTask = storageRef.put(
                      this.editedImage.infoImage
                    )
                    uploadTask.on(
                      'state_changed',
                      (snapshot) => {},
                      (error) => {
                        console.log('Error is ', error)
                      }
                    )
                    this.awaitDirect()
                    this.snackbar = true
                  } else {
                    this.textSnackbar = 'Thêm diễn viên thất bại'
                    this.snackbar = true
                  }
                }
              })
              .catch((error) => {
                console.log(error)
                this.textSnackbar = 'Có lỗi xảy trong quá trình thêm diễn viên'
                this.snackbar = true
              })
          }
        })
        .catch((response) => console.log(response))
    },
    async updateActor() {
      const data_update = {}
      data_update.id = this.actor.id
      data_update.code = this.actor.code
      data_update.name = this.actor.name
      data_update.introduce = this.actor.introduce
      if (this.editedImage.filename) {
        data_update.image_actor = this.editedImage.filename
      }
      await axios
        .post(`${process.env.URL_SERVER}/api/update-actor`, {
          data_update,
        })
        .then((response) => {
          if (response && response.data) {
            if (response.data.status) {
              this.textSnackbar = 'Cập nhật diễn viên thành công'
              this.awaitDirect()
              this.snackbar = true
            } else {
              this.textSnackbar = 'Cập nhật diễn viên thất bại'
              this.snackbar = true
            }
          }
        })
        .catch((error) => {
          console.log(error)
          this.textSnackbar = 'Có lỗi xảy trong quá trình cập nhật diễn viên'
          this.snackbar = true
        })
    },
    parseCodeActor() {
      if (this.actor.name !== '') {
        this.actor.code = this.convertViToEn(this.actor.name, false).replaceAll(
          ' ',
          '-'
        )
      }
    },
    convertViToEn(str, toUpperCase = true) {
      if (!str || str === '') {
        return ''
      }
      str = str.toLowerCase()
      str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, 'a')
      str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, 'e')
      str = str.replace(/ì|í|ị|ỉ|ĩ/g, 'i')
      str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, 'o')
      str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, 'u')
      str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, 'y')
      str = str.replace(/đ/g, 'd')
      // Some system encode vietnamese combining accent as individual utf-8 characters
      str = str.replace(/\u0300|\u0301|\u0303|\u0309|\u0323/g, '') // Huyền sắc hỏi ngã nặng
      str = str.replace(/\u02C6|\u0306|\u031B/g, '') // Â, Ê, Ă, Ơ, Ư

      return toUpperCase ? str.toUpperCase() : str
    },
  },
}
</script>
<style>
.required label::after {
  content: ' * ';
  color: red;
}
.required .v-label {
  color: red;
  opacity: 1;
}
</style>
