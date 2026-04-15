# Wisdom about Cloud Services

On github.com, you can view the table of contents (outline) of this file by
clicking the menu icon (three lines or dots) in the top corner.  It's next to
the pencil "edit" icon and below the word "History".

UW generally prefers that its researchers accesses cloud resources or LLMs via
  one of the large cloud providers (e.g.,
  [Google Cloud Platform (GCP)](https://cloud.google.com),
  [Amazon Web Services (AWS)](https://aws.amazon.com),
  or [Microsoft Azure](https://azure.microsoft.com).

## Working with Google Cloud Platform (GCP)

There is no requirement on the account you use for GCP (i.e., it can be your
  personal account,
  does not need to be a `@uw.edu` account).
The first step is to create a GCP _organization_, under which you'll create a _project_.
An organization is the top-level entity in GCP under which all projects are organized.
A project houses resources you can spin up in GCP,
  such as VMs,
  storage,
  and access to LLMs APIs.
Follow [these instructions](https://docs.cloud.google.com/resource-manager/docs/creating-managing-organization)
  to create an organization.

Once you have created an organization,
  you can create a project.
A project is the ["base level where all Google Cloud services (APIs) are enabled and where resource like Compute Engine instances or BigQuery datasets are created."](https://docs.cloud.google.com/resource-manager/docs/creating-managing-projects).
Ensure you are on the project you created on the [GCP Console](https://console.cloud.google.com/).
After you've created the project,
  ensure that you've set up billing for it,
  otherwise you will not be able to use any resources.
Set up billing by going to the "Billing" menu from the hamburger menu that appears in the top left-hand
  corner.

You'll then need to enable the API you want to use in the project:
    (select the project from the project picker on the top bar).
  - Select the "API & Services" menu from the hamburger menu that appears in the top left-hand corner.
  - Select "Enable APIs and services" and choose the API you want to enable (e.g., Vertex AI API).

After this is complete,
  try to generate an [API key for your project](https://console.cloud.google.com/vertex-ai/studio/settings/api-keys).
If this setting is disabled,
  you are likely missing permissions at the organization level that you'll need to set
  (recall that your project lives underneath your org, and inherits all permissions from it).
You'll likely need to grant yourself (in your organization) the "Organization Policy Administrator"
  and the "Organization Administrator" roles:

  - Go to GCP and select the organization under which your project has been created.
  - Click on IAM & Admin from the hamburger menu.
  - Edit your user and add Roles: "Organization Policy Administrator" and "Organization Administrator".
    - If theses roles don't appear, double-check that you have selected your organization and _not_
      your project.
  - Now with those 2 roles, click on "Organization Policies" under IAM & Admin, then select "Organization Policies".
  - Search for "Disable service account key creation" and edit as required.

Try creating the API key again.
