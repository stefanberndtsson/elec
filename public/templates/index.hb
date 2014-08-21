<div class="container">
  <div class="panel panel-default">
    <div class="panel-heading">
      <form class="form" role="form">
	<div class="input-group">
	  {{input name="query" class="form-control" value=search_query action="search"}}
	  <span class="input-group-btn">
	    <button class="btn btn-default" {{action "search"}}>Search</button>
	  </span>
	</div>
      </form>
    </div>
    <div class="panel-body">
      {{outlet}}
    </div>
  </div>
</div>
