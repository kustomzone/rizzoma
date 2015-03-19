{BaseModule} = require('../../share/base_module')
{Request} = require('../../share/communication')
{PlaybackWaveViewModel} = require('./wave_view_model')

render = window.CoffeeKup.compile ->
    div '.playback-container search', ->
        div '.js-playback-topic-container.playback-topic-container', ''

class Playback extends BaseModule
    constructor: (args...) ->
        super(args...)
        @_waveProcessor = require('../wave/processor').instance
        @_createDOM()

    _createDOM: ->
        @_container = $(render())[0]

    showPlaybackView: (request) ->
        waveId = request.args.waveId
        blipId = request.args.blipId
        @_waveProcessor.getPlaybackData(waveId, blipId, (err, waveData, waveBlips) =>
            return console.log(err) if err
            request = new Request({container: @_container})
            @_viewModel = new PlaybackWaveViewModel(@_waveProcessor, waveData, waveBlips, no, @)
            @_rootRouter.handle('navigation.showPlaybackView', request)
            $('.js-resizer').addClass('playback')
        )

    hidePlaybackView: (request) ->
        @_viewModel.destroy() if @_viewModel
        delete @_viewModel
        $('.js-resizer').removeClass('playback')

    getWaveContainer: -> $(@_container).find('.js-playback-topic-container')[0]

module.exports.Playback = Playback