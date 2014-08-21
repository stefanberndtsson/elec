<table class="table">
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Tags</th>
  </tr>
  {{#each item in model.query}}
  <tr>
    <td>{{file-link item=item}}</a></td>
    <td>{{item.file_type}}</td>
    <td>
      {{#each tag in item.tags}}
      <span class="label label-default">{{tag}}</span>
      {{/each}}
    </td>
  </tr>
  {{/each}}
</table>
