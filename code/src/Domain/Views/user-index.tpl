<p>Список пользователей в хранилище</p>

      <div class="table-responsive small">
        <table class="table table-striped table-sm">
          <thead>
            <tr>
              <th scope="col">ID</th>
              <th scope="col">Имя</th>
              <th scope="col">Фамилия</th>
              <th scope="col">День рождения</th>
              {% if isAdmin %}
              <th scope="col">Действия</th>
              {% endif %}
            </tr>
          </thead>
          <tbody>
            {% for user in users %}
            <tr>       
              <td>{{ user.getUserId() }}</td>   
              <td>{{ user.getUserName() }}</td>
              <td>{{ user.getUserLastName() }}</td>
              <td>{% if user.getUserBirthday() is not empty %}
                    {{ user.getUserBirthday() | date('d.m.Y') }}
                  {% else %}
                    <b>Не задан</b>
                  {% endif %}
              </td>
              {% if isAdmin %}
              <td>
                  <a href="/user/edit/?user_id={{ user.getUserId() }}">Редактировать</a>
                  <a href="#" class="delete-user" data-user-id="{{ user.getUserId() }}">Удалить</a>
              </td>
              {% endif %}
            </tr>
            {% endfor %}
          </tbody>
        </table>
      </div>

<script>
    let maxId = $('.table-responsive tbody tr:last-child td:first-child').html();
  
    setInterval(function () {
      $.ajax({
          method: 'POST',
          url: "/user/indexRefresh/",
          data: { maxId: maxId }
      }).done(function (response) {
          // $('.content-template').html(response);

          let users = $.parseJSON(response);
          
          if(users.length != 0){
            for(var k in users){

              let row = "<tr>";

              row += "<td>" + users[k].id + "</td>";
              maxId = users[k].id;

              row += "<td>" + users[k].username + "</td>";
              row += "<td>" + users[k].userlastname + "</td>";
              row += "<td>" + users[k].userbirthday + "</td>";

              row += "</tr>";

              $('.content-template tbody').append(row);
            }
            
          }
          
      });
    }, 10000);
</script>
<script>
    $('.delete-user').on('click', function (e) {
        e.preventDefault();
        const userId = $(this).data('user-id');

        if (confirm('Вы уверены, что хотите удалить этого пользователя?')) {
            $.ajax({
                method: 'POST',
                url: '/user/delete/',
                data: { user_id: userId },
                success: function (response) {
                    const result = JSON.parse(response);
                    if (result.success) {
                        $('#user-row-' + userId).remove();
                    } else {
                        alert(result.message || 'Ошибка удаления пользователя.');
                    }
                },
                error: function () {
                    alert('Не удалось отправить запрос.');
                }
            });
        }
    });
</script>