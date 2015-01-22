class App

    selectors:

        track: ".track"
        trackDate: ".track__date"
        trackSubmit: ".track__submit"

        results: ".results"
        resultsRow: ".results__row"
        resultsItem: ".results__item"
        shipment: ".shipment"
        shipmentCollapse: ".shipment__collapse"

        loginBg: ".login__bg"
        loginClose: ".login__close"
        loginSubmit: ".login__submit-button"

        backToForm: ".results__header-button"
        instantSearch: ".results__summary-search-input"
        openLogin: ".header__nav-link_login"

        footer: ".footer"

    classes:
        active: "m-active"
        animated: "m-animated"
        login: "m-login"
        hidden: "m-hidden"

    SCROLL_INDENT: 400
    ANIMATION_DURATION: 200

    constructor: (@selector) ->

        @container = $ @selector
        unless @container.length
            throw new Error "No container provided", @selector

    initialize: ->

        for key, selector of @selectors
            @[key] = @container.find selector

        @container.find("a[href=#]").on "click", (e) ->
            e.preventDefault()

        @initializeTrackForm()
        @initializeResults()
        @initializeLogin()
        @initializeInstantSearch()

        console.log "Initialized app", container: @container

    initializeTrackForm: ->

        @trackSubmit.on "click", =>
            @track.addClass @classes.animated
            setTimeout =>
                @track
                    .hide()
                    .removeClass @classes.animated
                @results.fadeIn @ANIMATION_DURATION
            , @ANIMATION_DURATION

        @backToForm.on "click", =>
            @results.fadeOut =>
                @track.show()

        @trackDate.datepicker
            dateFormat: "M dd"

    initializeResults: ->

        @shipment.tabs()

        @resultsRow.on "click", (e) =>

            currentRow = $ e.currentTarget

            currentRow
                .next()
                .find(@selectors.resultsItem)
                .toggleClass(@classes.active)

            currentRow
                .next()
                .siblings()
                .find(@selectors.resultsItem)
                .removeClass(@classes.active)

        @resultsRow.one "click", =>
            @footer.css paddingBottom: @SCROLL_INDENT

        @shipmentCollapse.on "click", (e) =>
            $(e.currentTarget)
                .parents @selectors.resultsItem
                .removeClass @classes.active

    initializeLogin: ->

        @openLogin.on "click", =>
            @container.addClass @classes.login

        @loginClose
            .add(@loginBg)
            .add(@loginSubmit)
            .on "click", =>
                @container.removeClass @classes.login

    initializeInstantSearch: ->

        @resultsRow.each (i, element) ->
            row = $ element
            indexed = row
                .text()
                .replace(/\n/g, "")
                .replace(/\s+/g, " ")
                .trim()
            row.data indexed: indexed

        @instantSearch.on "keyup", _.debounce(((e) => @onSearchFieldKeyup(e)), 300)

    onSearchFieldKeyup: (e) ->

        target = $(e.currentTarget)
        value = target.val()

        try
            regExp = new RegExp("(?:^|-|_|,|\\.|\\s)" + value, "i")
        catch e
            return

        matches = @resultsRow.filter (i, element) ->
            text = $(element).data "indexed"
            regExp.test text

        @resultsRow
            .removeClass @classes.hidden
            .not(matches)
            .addClass @classes.hidden
