@extends('layout.default')

@if($mode == 'edit')
@section('title', $__t('Edit Barcode'))
@else
@section('title', $__t('Create Barcode'))
@endif

@section('content')
<div class="row">
	<div class="col">
		<div class="title-related-links">
			<h2 class="title">
				@yield('title')<br>
				<span class="text-muted small">{{ $__t('Barcode for location') }} <strong>{{ $location->name }}</strong></span>
			</h2>
		</div>
	</div>
</div>

<hr class="my-2">

<div class="row">
	<div class="col-lg-6 col-12">

		<script>
			Grocy.EditMode = '{{ $mode }}';
			Grocy.EditObjectLocation = {!! json_encode($location) !!};
		</script>

		@if($mode == 'edit')
		<script>
			Grocy.EditObjectId = {{ $barcode->id }};
			Grocy.EditObject = {!! json_encode($barcode) !!};
		</script>
		@endif

		<form id="barcode-form"
			novalidate>

			<input type="hidden"
				name="location_id"
				value="{{ $location->id }}">

			<div class="form-group">
				<label for="name">{{ $__t('Barcode') }}&nbsp;<i class="fa-solid fa-barcode"></i></label>
				<div class="input-group">
					<input type="text"
						class="form-control barcodescanner-input"
						required
						id="barcode"
						name="barcode"
						value="@if($mode == 'edit'){{ $barcode->barcode }}@endif"
						data-target="#barcode"
						data-target-type="location">
					@include('components.camerabarcodescanner')
				</div>
			</div>

			<div class="form-group">
				<label for="note">{{ $__t('Note') }}</label>
				<input type="text"
					class="form-control"
					id="note"
					name="note"
					value="@if($mode == 'edit'){{ $barcode->note }}@endif">
			</div>

			@include('components.userfieldsform', array(
			'userfields' => $userfields,
			'entity' => 'location_barcodes'
			))

			<button id="save-barcode-button"
				class="btn btn-success">{{ $__t('Save') }}</button>

		</form>
	</div>
</div>
@stop
