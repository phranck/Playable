import { PlayableService, type PlayableServiceName } from "@playable/contracts";

/**
 * The canonical name this workspace deploys under.
 *
 * Configuration, deployment and inter-service URLs all address the backend by
 * this name, and taking it from the shared contract rather than repeating the
 * string keeps the deployment definition and the running process in step.
 */
export const serviceName: PlayableServiceName = PlayableService.Backend;
