# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'UEFN mini games'
copyright = '2023, Petlja'
author = 'Petlja'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = ["myst_parser", "sphinx_design", "sphinx_copybutton"]
myst_enable_extensions = ["colon_fence"]

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store','.venv','.git', 'README.md']



# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output


html_title = 'Concept mini games for learning Verse and UEFN'

#html_theme = 'alabaster'
html_theme = 'furo'
#html_theme = 'sphinx_book_theme'

html_static_path = ['_static']

myst_html_meta = {
    "robots": "noindex, nofollow",
}
