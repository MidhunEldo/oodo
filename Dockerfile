# Use an official Odoo image as a parent image
FROM odoo:16.0

# Set environment variables for paths (optional, but good practice)
ENV ODOO_RC /etc/odoo/odoo.conf
ENV ODOO_EXTRA_ADDONS_DIR /mnt/extra-addons

# Copy your custom configuration file to the container
# The official Odoo image will load /etc/odoo/odoo.conf by default
COPY ./config/odoo.conf ${ODOO_RC}

# Copy your custom addons to the container
# Ensure the destination directory exists and has correct permissions if not using ODOO_EXTRA_ADDONS_DIR
# For this example, we are using the addons_path specified in odoo.conf
COPY ./addons ${ODOO_EXTRA_ADDONS_DIR}

# Odoo runs as the 'odoo' user (UID 101). Ensure this user can access the files.
# The base Odoo image often handles permissions for /mnt/extra-addons,
# but explicitly setting ownership can prevent issues.
USER root
RUN chown -R odoo:odoo ${ODOO_EXTRA_ADDONS_DIR} && \
    chown odoo:odoo ${ODOO_RC}
USER odoo

# Expose Odoo ports (optional if already exposed by base image, but good for clarity)
EXPOSE 8069
EXPOSE 8072

# The CMD is usually inherited from the base image (e.g., ["odoo"])
# If you need to pass specific command-line arguments not covered by odoo.conf:
# CMD ["odoo", "--config=/etc/odoo/odoo.conf"]
