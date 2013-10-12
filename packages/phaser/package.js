Package.describe({
  summary: "Phaser"
});

Package.on_use(function (api) {
  api.add_files([
    'phaser.js'
  ], ['client', 'server']);

  api.export('Phaser', 'client');
});
