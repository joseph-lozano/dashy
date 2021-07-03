module.exports = {
  purge: [
    "../lib/**/*.ex",
    "../lib/**/*.leex",
    "../lib/**/*.eex",
    "./js/**/*.js",
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      height: (theme) => ({
        "1/12": "8.333333%;",
        "5/12": "41.66666%;",
      }),
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
