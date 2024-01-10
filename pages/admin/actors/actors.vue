<!-- eslint-disable camelcase -->
<template>
  <v-container fluid color="error">
    <v-snackbar v-model="snackbar">
      {{ textSnackbar }}

      <template v-slot:action="{ attrs }">
        <v-btn color="pink" text v-bind="attrs" @click="snackbar = false">
          Đóng
        </v-btn>
      </template>
    </v-snackbar>
    <v-dialog v-model="dialogDelete" width="unset">
      <v-sheet outlined color="error" rounded>
        <v-card>
          <v-card-title class="h5 red--text"
            >Bạn có chắc muốn xóa không?</v-card-title
          >
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="error" text @click="closeDelete">Không</v-btn>
            <v-btn color="error" text @click="deleteActorConfirm">Có</v-btn>
            <v-spacer></v-spacer>
          </v-card-actions>
        </v-card>
      </v-sheet>
    </v-dialog>
    <v-card>
      <v-card-title style="left: 50%" class="red--text font-weight-bold"
        >QUẢN LÝ DIỄN VIÊN PHIM TRÊN WMOVIES
      </v-card-title>
      <v-card-text>
        <v-data-table
          :search="search"
          :headers="headers"
          :items="actors"
          :footer-props="{
            itemsPerPageText: 'số dòng mỗi trang',
            pageText: '{0}-{1} trên {2}',
          }"
          item-key="id"
          class="elevation-1"
          loading-text="Đang tải...vui lòng đợi"
        >
          <template #top>
            <v-snackbar v-model="snackbar">
              {{ textSnackbar }}

              <template v-slot:action="{ attrs }">
                <v-btn
                  color="pink"
                  text
                  v-bind="attrs"
                  @click="snackbar = false"
                >
                  Close
                </v-btn>
              </template>
            </v-snackbar>
            <v-toolbar flat>
              <v-text-field
                v-model="search"
                append-icon="mdi-magnify"
                label="Tìm diễn viên..."
                single-line
                hide-details
                @keyup.enter="searchAll"
              ></v-text-field>
              <v-spacer></v-spacer>
              <v-btn outlined color="error" class="mb-2" @click="addActor()">
                Thêm diễn viên
              </v-btn>
            </v-toolbar>
          </template>

          <template #[`item.actions`]="{ item }">
            <v-icon small class="mr-2" @click="editActor(item)">
              mdi-pencil
            </v-icon>
            <v-icon small @click="deleteActor(item)"> mdi-delete </v-icon>
          </template>
          <template #no-data>
            <v-btn color="error" @click="loadActors"> Làm mới </v-btn>
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>
  </v-container>
</template>
<script>
// import axios from 'axios'
import gql from 'graphql-tag'
import moment from 'moment'
export default {
  layout: 'admin',
  name: 'Categories',
  data() {
    return {
      snackbar: false,
      textSnackbar: '',
      search: '',
      dialogDelete: false,
      headers: [
        {
          text: 'STT',
          value: 'stt',
          align: 'start',
          class: 'error font-weight-medium text-h6 white--text',
        },

        {
          text: 'Mã diễn viên',
          value: 'code',
          class: 'error font-weight-medium text-h6 white--text',
        },
        {
          text: 'Tên diễn viên',
          value: 'name',
          class: 'error font-weight-medium text-h6 white--text',
        },
        {
          text: 'Ngày tạo',
          value: 'created_at_string',
          class: 'error font-weight-medium text-h6 white--text',
        },
        {
          text: '',
          value: 'actions',
          sortable: false,
          class: 'error font-weight-medium text-h6 white--text',
        },
      ],
      actors: [],
      actor: {
        id: null,
        code: null,
        name: null,
        introduce: null,
        image_actor: null,
        created_at: null,
      },
      editedIndex: -1,
    }
  },
  mounted() {},
  watch: {},
  methods: {
    closeDelete() {
      this.dialogDelete = false
      this.editedIndex = -1
    },
    getTotalData(data) {},
    editActor(item) {
      this.$router.push({
        path: `/admin/actors/actors_edit`,
        query: { id: item.id },
      })
    },
    deleteActor(item) {
      this.editedIndex = this.actors.indexOf(item)
      if (this.editedIndex !== -1) {
        const queryCheck = gql` query MyQuery {
            movie_actors(
              where: { actor_id: { _eq: ${item.id} }, movie: { is_delete: {_eq: false}} }
            ) {
              id
              actor_id
              movie_id
            }
          }`
        this.$apollo
          .query({
            query: queryCheck,
            fetchPolicy: 'no-cache',
          })
          .then((response) => {
            if (
              response &&
              response.data &&
              response.data.movie_actors &&
              response.data.movie_actors.length > 0
            ) {
              this.textSnackbar =
                'Vui lòng xóa phim có diễn viên hoặc cập nhật lại danh sách diễn viên của phim này'
              this.snackbar = true
            } else {
              this.dialogDelete = true
            }
          })
          .catch((response) => {
            console.log(response)
            this.textSnackbar = 'Có lỗi xảy ra, vui lòng thử lại'
            this.snackbar = true
          })
      } else {
        this.snackbar = true
        this.textSnackbar = 'Không tìm thấy diễn viên'
      }
    },
    loadActors() {
      this.$apollo.queries.getData.refetch()
    },
    deleteActorConfirm() {
      const getItem = this.actors[this.editedIndex]
      const updateGraphl = gql` mutation MyMutation {
            update_actors(
              where: { id: { _eq: "${getItem.id}" } }
              _set: {
                is_delete: true
              }
            ) {
              affected_rows
            }
          }`
      this.$apollo.mutate({
        mutation: updateGraphl,
        variables: {},
        // eslint-disable-next-line camelcase
        update: (store, { data: { update_actors } }) => {
          // eslint-disable-next-line camelcase
          if (update_actors.affected_rows) {
            this.$apollo.queries.getData.refetch()
            this.textSnackbar = 'Xóa diễn viên thành công'
            this.snackbar = true
            this.closeDelete()
          } else {
            this.textSnackbar = 'Xóa diễn viên thất bại'
            this.snackbar = true
            this.closeDelete()
          }
        },
      })
    },
    addActor() {
      this.$router.push({
        path: `/admin/actors/actors_edit`,
        query: { id: 0 },
      })
    },
    searchAll() {},
  },
  apollo: {
    getData: {
      query() {
        const query = gql(`query MyQuery {
                 actors(where: {is_delete: {_eq: false}}) {
                    id
                    code
                    name
                    image_actor
                    created_at
                 }
              }`)
        return query
      },
      update: (data) => {},
      result({ data }) {
        this.actors = []
        if (data && data.actors && data.actors.length > 0) {
          for (let index = 0; index < data.actors.length; index++) {
            const element = data.actors[index]
            element.stt = index + 1
            element.created_at_string = moment(element.created_at)
              .add('hours', 7)
              .format('DD-MM-YYYY HH:mm:ss')

            this.actors.push(element)
          }
        }
      },
    },
  },
}
</script>

<style></style>
